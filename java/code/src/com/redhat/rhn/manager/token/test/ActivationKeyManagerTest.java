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
package com.redhat.rhn.manager.token.test;

import java.util.HashSet;
import java.util.Set;

import com.redhat.rhn.domain.channel.Channel;
import com.redhat.rhn.domain.role.RoleFactory;
import com.redhat.rhn.domain.server.Server;
import com.redhat.rhn.domain.server.test.ServerFactoryTest;
import com.redhat.rhn.domain.token.ActivationKey;
import com.redhat.rhn.domain.token.Token;
import com.redhat.rhn.domain.user.User;
import com.redhat.rhn.manager.token.ActivationKeyManager;
import com.redhat.rhn.testing.BaseTestCaseWithUser;
import com.redhat.rhn.testing.ChannelTestUtils;
import com.redhat.rhn.testing.UserTestUtils;


/**
 * ActivationKeyManagerTest
 * @version $Rev$
 */
public class ActivationKeyManagerTest extends BaseTestCaseWithUser {
    private ActivationKeyManager manager;
    
    public void setUp() throws Exception {
        super.setUp();
        manager = ActivationKeyManager.getInstance();
    }
    public void testDelete() throws Exception {
        user.addRole(RoleFactory.ACTIVATION_KEY_ADMIN);
        ActivationKey key = manager.createNewActivationKey(user, "Test");
        ActivationKey temp = manager.lookupByKey(key.getKey(), user);
        assertNotNull(temp);
        manager.remove(temp);
        try {
            temp = manager.lookupByKey(key.getKey(), user);
            String msg = "NUll lookup failed, because this object should exist!";
            fail(msg);
        }
        catch (Exception e) {
         // great!.. Exception for null lookpu is controvoersial but convenient..
        }
    }
    
    public void testLookup() {
        //first lets just check on permissions...
        user.addRole(RoleFactory.ACTIVATION_KEY_ADMIN);
        final ActivationKey key = manager.createNewActivationKey(user, "Test");
        ActivationKey temp;
        //we make newuser
        // unfortunately satellite is NOT multiorg aware... 
        //So we can't check on the org clause 
        //so...
        User newUser = UserTestUtils.findNewUser("testUser2", "testOrg");
        try {
            manager.lookupByKey(key.getKey(), newUser);
            String msg = "Permission check failed :(.." +
                            "Activation key should not have gotten found out" +
                         " because the user does not have activation key admin role";
                         
            fail(msg);
        }
        catch (Exception e) {
            // great!.. Exception for permission failure always welcome
        }        
        try {
            temp = manager.lookupByKey(key.getKey() + "FOFOFOFOFOFOF", user);
            String msg = "NUll lookup failed, because this object should NOT exist!";
            fail(msg);
        }
        catch (Exception e) {
         // great!.. Exception for null lookpu is controvoersial but convenient..
        }
        temp = manager.lookupByKey(key.getKey(), user);
        assertNotNull(temp);
        assertEquals(user.getOrg(), temp.getOrg());
    }
    
    public void testCreatePermissions() throws Exception {
        ActivationKey key;
        //test permissions
        try {
            key = manager.createNewActivationKey(user,  "Test");
            String msg = "Permission check failed :(.." +
                            "Activation key should not have gotten created" +
                            " because the user does not have activation key admin role";
            fail(msg);
        }
        catch (Exception e) {
            // great!.. Exception for permission failure always welcome
        }

        //test permissions
        try {
            String keyName = "I_RULE_THE_WORLD";
            Long usageLimit = new Long(1200); 
            Channel baseChannel = ChannelTestUtils.createBaseChannel(user);
            String note = "Test";    
            key = manager.createNewActivationKey(user, 
                                                    keyName, note, usageLimit, 
                                                    baseChannel, true);

            String msg = "Permission check failed :(.." +
                            "Activation key should not have gotten created" +
                            " becasue the user does not have activation key admin role";
            fail(msg);
        }
        catch (Exception e) {
            // great!.. Exception for permission failure always welcome
        }
        
    }
    
    public void testCreate() throws Exception {
        user.addRole(RoleFactory.ACTIVATION_KEY_ADMIN);
        String note = "Test";
        final ActivationKey key = manager.createNewActivationKey(user, note);
        assertEquals(user.getOrg(), key.getOrg());
        assertEquals(note, key.getNote());
        assertNotNull(key.getKey());
        Server server = ServerFactoryTest.createTestServer(user, true);
                
        final ActivationKey key1 = manager.createNewReActivationKey(user, server, note);
        assertEquals(server, key1.getServer());
        
        ActivationKey temp = manager.lookupByKey(key.getKey(), user);
        assertNotNull(temp);
        assertEquals(user.getOrg(), temp.getOrg());
        assertEquals(note, temp.getNote());
        
        String keyName = "I_RULE_THE_WORLD";
        Long usageLimit = new Long(1200); 
        Channel baseChannel = ChannelTestUtils.createBaseChannel(user);
        
        final ActivationKey key2 = manager.createNewReActivationKey(user, server,
                                                keyName, note, usageLimit, 
                                                baseChannel, true);
        
        
        temp = (ActivationKey)reload(key2);
        assertTrue(temp.getKey().endsWith(keyName));
        assertEquals(note, temp.getNote());
        assertEquals(usageLimit, temp.getUsageLimit());
        Set channels = new HashSet();
        channels.add(baseChannel);
        assertEquals(channels, temp.getChannels());
        
        //since universal default == true we have to 
        // check if the user org has it..        
        Token token = user.getOrg().getToken();
        assertEquals(channels, token.getChannels());
        assertEquals(usageLimit, token.getUsageLimit());
    }
    
    public ActivationKey createActivationKey() throws Exception {
        user.addRole(RoleFactory.ACTIVATION_KEY_ADMIN);
        return  manager.createNewActivationKey(user, "Test");
    }

}
