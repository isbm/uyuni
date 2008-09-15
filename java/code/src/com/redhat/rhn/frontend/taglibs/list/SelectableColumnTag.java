/**
 * Copyright (c) 2008 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 * 
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation. 
 */
package com.redhat.rhn.frontend.taglibs.list;

import com.redhat.rhn.common.localization.LocalizationService;
import com.redhat.rhn.manager.rhnset.RhnSetDecl;

import org.apache.commons.lang.StringUtils;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * Implements a simple selected checkbox like those used with RhnSets
 * 
 * @version $Rev $
 */
public class SelectableColumnTag extends TagSupport {
    
    private static final long serialVersionUID = 2749189931275777440L;
    
    private String valueExpr;
    private String selectExpr;
    private String disabledExpr;
    private String styleClass;
    private String width = "20px";
    private String headerStyle;
    private String headerKey;
    private String listName;
    private String rhnSet;
    /**
     * Sets the column width
     * @param widthIn column width
     */
    public void setWidth(String widthIn) {
        width = widthIn;
    }
    
    /**
     * Sets the header CSS style class
     * @param style CSS style class
     */
    public void setHeaderclass(String style) {
        headerStyle = style;
    }

    /**
     * Sets the header key
     * @param key the header key
     */
    public void setHeaderkey(String key) {
        headerKey = key;
    }
    /**
     * Sets the individual cells' CSS style class
     * @param style CSS style class
     */
    public void setStyleclass(String style) {
        styleClass = style;
    }
    
    /**
     * Sets the value for the cell
     * Should probably reference the ${current} variable in some way
     * @param valueIn  value for checkbox
     */
    public void setValue(String valueIn) {
        valueExpr = valueIn;
    }
    
    /**
     * Expression to determine if a checkbox is selected
     * @param expr selected expression 
     */
    public void setSelected(String expr) {
        selectExpr = expr;
    }
    
    /**
     * Expression to determine if checkbox is disabled
     * @param expr disabled expression
     */
    public void setDisabled(String expr) {
        disabledExpr = expr;
    }
    
    /**
     * {@inheritDoc}
     */
    public int doStartTag() throws JspException {
        
        ListCommand command = (ListCommand) 
            ListTagUtil.getCurrentCommand(this, pageContext);
        ListTag parent = (ListTag) BodyTagSupport.findAncestorWithClass(this, 
                ListTag.class);
        listName = parent.getUniqueName();
        int retval = BodyTagSupport.SKIP_BODY;
        setupRhnSet();
        if (command.equals(ListCommand.ENUMERATE)) {
            parent.addColumn();
            retval = BodyTagSupport.EVAL_PAGE;
        }
        else if (command.equals(ListCommand.COL_HEADER)) {
            renderHeader(parent);
            retval = BodyTagSupport.EVAL_PAGE;
        }
        else if (command.equals(ListCommand.RENDER)) {
            renderCheckbox();
        }
        return retval;
    }    

    /**
     * {@inheritDoc}
     */
    public int doEndTag() throws JspException {
        ListCommand command = (ListCommand) ListTagUtil.
                                            getCurrentCommand(this, pageContext);
        if (command.equals(ListCommand.RENDER)) {
            ListTagUtil.write(pageContext, "</td>");    
        }
        release();
        return BodyTagSupport.EVAL_PAGE;
    }
    
    /**
     * {@inheritDoc}
     */    
    public void release() {
        if (listName != null) {
            ListTagUtil.clearPersistentCounter(pageContext, listName);
        }
        listName = null;
        valueExpr = null;
        selectExpr = null;
        disabledExpr = null;
        styleClass = null;
        width = "20px";
        headerStyle = null;
    }
    
    private void renderHeader(ListTag parent) throws JspException {
        if (!parent.isEmpty()) {
            ListTagUtil.write(pageContext, "<th");
            if (headerStyle != null) {
                ListTagUtil.write(pageContext, " class=\"");
                ListTagUtil.write(pageContext, headerStyle);
                ListTagUtil.write(pageContext, "\"");
            }
            ListTagUtil.write(pageContext, ">");
            if (StringUtils.isBlank(headerKey)) {
                renderOnClickForSelectAll();    
            }
            else {
                LocalizationService ls = LocalizationService.getInstance();
                ListTagUtil.write(pageContext, ls.getMessage(headerKey));
            }
            ListTagUtil.write(pageContext, "</th>");            
        }
    }

    private void setupRhnSet() {
        RhnSetDecl decl = ListTagHelper.lookupSetDeclFor(listName, 
                                            pageContext.getRequest());
        if (decl != null) {
            rhnSet =  decl.getLabel();
        }
    }
    
    private void renderOnClickForSelectAll() throws JspException {
        ListTagUtil.write(pageContext, "<input type=\"checkbox\" ");
        ListTagUtil.write(pageContext, " name=\"");
        ListTagUtil.write(pageContext, makeSelectAllCheckboxName());
        ListTagUtil.write(pageContext, "\" ");
        ListTagUtil.write(pageContext, "onclick=\"");        
        ListTagUtil.write(pageContext, "process_check_all(");
        ListTagUtil.write(pageContext, "'");
        
        if (rhnSet != null) {
            ListTagUtil.write(pageContext, rhnSet);
        }
        ListTagUtil.write(pageContext, "', ");
        ListTagUtil.write(pageContext, "this.form." +
                        ListTagUtil.makeSelectedItemsName(listName));
        ListTagUtil.write(pageContext, ", this.checked)");
        ListTagUtil.write(pageContext, "\" />");        
    }
    private void renderCheckbox() throws JspException {
        render(valueExpr);
    }
    
    private void render(String value) throws JspException {
        writeStartingTd();
        String counterName = "list_sel_" + listName;
        Long id = ListTagUtil.incrementPersistentCounter(pageContext, counterName);
        renderHiddenItem(id, value);
        ListTagUtil.write(pageContext, "<input type=\"checkbox\" ");
        if (isSelected()) {
            ListTagUtil.incrementPersistentCounter(pageContext, listName + "_selected");
            ListTagUtil.write(pageContext, "checked ");
        }
        if (isDisabled()) {
            ListTagUtil.write(pageContext, "disabled ");
        }
        ListTagUtil.write(pageContext, "id=\"");
        ListTagUtil.write(pageContext, makeCheckboxId(id));
        ListTagUtil.write(pageContext, "\" name=\"" + ListTagUtil.
                                            makeSelectedItemsName(listName) + "\" ");
        ListTagUtil.write(pageContext, "value=\"");
        ListTagUtil.write(pageContext, value);
        ListTagUtil.write(pageContext, "\" ");
        if (rhnSet != null) {
            renderRhnSetOnClick();
        }
        ListTagUtil.write(pageContext, "/>");
    }

    private String makeSelectAllCheckboxName() {
        return "list_" + listName + "_sel_all";
    }    
    
    private String makeCheckboxId(Long id) {
        return "list_" + listName + "_" + id;
    }    
    /**
     * renders
     * //onclick="checkbox_clicked(this, '$rhnSet')"
     *
     */
    private void renderRhnSetOnClick() throws JspException {
        ListTagUtil.write(pageContext, " onclick=\"process_checkbox_clicked(this,'");
        ListTagUtil.write(pageContext, rhnSet);
        ListTagUtil.write(pageContext, "',");
        ListTagUtil.write(pageContext, "this.form." + makeSelectAllCheckboxName());
        ListTagUtil.write(pageContext, ")\" ");
    }

    private void renderHiddenItem(Long listId, String value) throws JspException {
        ListTagUtil.write(pageContext, "<input type=\"hidden\" ");
        ListTagUtil.write(pageContext, "id=\"");
        ListTagUtil.write(pageContext, "list_items_" + listName + "_" + listId);
        ListTagUtil.write(pageContext, "\" name=\"" + 
                            ListTagUtil.makePageItemsName(listName) + "\" ");
        ListTagUtil.write(pageContext, "value=\"");
        ListTagUtil.write(pageContext, value);
        ListTagUtil.write(pageContext, "\" />\n");        
    }
    
    private boolean isSelected() throws JspException {
        if (selectExpr != null && selectExpr.equalsIgnoreCase("true")) {
            return true;
        }
        return false;
    }
    
    private boolean isDisabled() throws JspException {
        if (disabledExpr != null && disabledExpr.equalsIgnoreCase("true")) {
            return true;
        }
        return false;
    }
    
    protected void writeStartingTd() throws JspException {
        ListTagUtil.write(pageContext, "<td");
        if (styleClass != null) {
            ListTagUtil.write(pageContext, " class=\"");
            ListTagUtil.write(pageContext, styleClass);
            ListTagUtil.write(pageContext, "\"");
        }
        if (width != null) {
            ListTagUtil.write(pageContext, " width=\"");
            ListTagUtil.write(pageContext, width);
            ListTagUtil.write(pageContext, "\"");
        }
        ListTagUtil.write(pageContext, ">");       
    }    
}
