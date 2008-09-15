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
package com.redhat.rhn.frontend.action.schedule.test;

import com.redhat.rhn.frontend.action.schedule.ScheduledActionSetupAction;
import com.redhat.rhn.testing.ActionHelper;
import com.redhat.rhn.testing.RhnBaseTestCase;

/**
 * ScheduledActionSetupActionTestCase
 * @version $Rev$
 */
public abstract class ScheduledActionSetupActionTestCase extends RhnBaseTestCase {

    protected void testPerformExecute(ScheduledActionSetupAction action) throws Exception {
        ActionHelper sah = new ActionHelper();
        sah.setUpAction(action);
        sah.getRequest().setupAddParameter("newset", (String)null);
        sah.setupClampListBounds();
        sah.getRequest().setupAddParameter("returnvisit", (String) null);
        sah.executeAction();
        
        assertNotNull(sah.getRequest().getAttribute("pageList"));
        assertNotNull(sah.getRequest().getAttribute("user"));
        assertNotNull(sah.getRequest().getAttribute("set"));
    }

}
