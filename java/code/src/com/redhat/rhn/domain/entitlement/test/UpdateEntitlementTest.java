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
package com.redhat.rhn.domain.entitlement.test;

import com.redhat.rhn.domain.entitlement.UpdateEntitlement;
import com.redhat.rhn.manager.entitlement.EntitlementManager;

/**
 * EntitlementManagerTest
 * @version $Rev$
 */
public class UpdateEntitlementTest extends BaseEntitlementTestCase {

    protected void createEntitlement() {
        ent = new UpdateEntitlement();
    }

    protected String getLabel() {
        return EntitlementManager.SW_MGR_ENTITLED;
    }
}
