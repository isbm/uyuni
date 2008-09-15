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
package com.redhat.rhn.manager.kickstart;

import com.redhat.rhn.common.security.SessionSwap;
import com.redhat.rhn.domain.user.User;
import com.redhat.rhn.frontend.action.kickstart.KickstartHelper;

import org.apache.commons.lang.StringEscapeUtils;

import java.net.MalformedURLException;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;

/**
 * Simple class to reduce dependencies between Struts and database laysers
 * 
 * @version $Rev $
 */
public class KickstartFileDownloadCommand extends BaseKickstartCommand {
    private KickstartHelper helper;
    private String protocol;
    
    /**
     * Constructor
     * @param ksidIn kickstart id
     * @param userIn logged in user
     * @param request HttpServletRequest
     */
    public KickstartFileDownloadCommand(Long ksidIn, User userIn, 
            HttpServletRequest request) {
        super(ksidIn, userIn);
        helper = new KickstartHelper(request);
        try {
            URL url = new URL(request.getRequestURL().toString());
            protocol = url.getProtocol();
        }
        catch (MalformedURLException e) {
            throw new IllegalArgumentException("Bad argument when creating URL for " +
            "Kickstart File Download");
        }
    }
    
    /**
     * 
     * @return string contents of kickstart file
     */
    public String getFileData() {
        
        KickstartFormatter profile = 
            new KickstartFormatter(helper.getKickstartHost(), ksdata);
        String data = profile.getFileData();        
        return data;
    }
    
    /**
     * 
     * @return the url used to view the kickstart file
     */
    public String getViewURL() {    
        return getKickstartUrl(this.protocol, "view_label") + 
            StringEscapeUtils.escapeHtml(getKickstartData().getLabel());
    }
     
    /**
     * Get the URL to the org_default for this Org.  Looks like this:
     * 
     * https://rhn.redhat.com/kickstart/ks/org/
     *   2824120xe553d920d21606ccfc668e13bd8d8e3f/org_default
     * 
     * @return String url
     */
    public String getOrgDefaultUrl() { 
        return getKickstartUrl(protocol, "org_default");
    }
    
    private String getKickstartUrl(String protocolIn, String type) {
        String host = helper.getKickstartHost();
        String org = ksdata.getOrg().getId().toString();
        String url = protocolIn + "://" + host + "/kickstart/ks/org/" + org + "x" + 
        SessionSwap.generateSwapKey(org) + "/" + type + 
            "/";
        return url;
        
    }
}
