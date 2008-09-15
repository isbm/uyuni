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
package com.redhat.rhn.domain.rhnpackage.test;

import com.redhat.rhn.common.db.datasource.ModeFactory;
import com.redhat.rhn.common.db.datasource.WriteMode;
import com.redhat.rhn.domain.channel.Channel;
import com.redhat.rhn.domain.channel.test.ChannelFactoryTest;
import com.redhat.rhn.domain.rhnpackage.Package;
import com.redhat.rhn.domain.rhnpackage.PackageFactory;
import com.redhat.rhn.domain.server.InstalledPackage;
import com.redhat.rhn.domain.server.Server;
import com.redhat.rhn.domain.server.ServerFactory;
import com.redhat.rhn.domain.server.test.ServerFactoryTest;
import com.redhat.rhn.domain.user.User;
import com.redhat.rhn.frontend.dto.PackageOverview;
import com.redhat.rhn.testing.BaseTestCaseWithUser;
import com.redhat.rhn.testing.UserTestUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;


/**
 * PackageFactoryTest
 * @version $Rev$
 */
public class PackageFactoryTest extends BaseTestCaseWithUser {

    /**
     * Test fetching a Package with the logged in User
     * @throws Exception
     */
    public void testLookupWithUser() throws Exception {
        Package pkg = PackageTest.createTestPackage();
        assertNotNull(pkg.getOrg().getId());

        User usr = UserTestUtils.createUser("testUser", pkg.getOrg().getId());
        Package pkg2 = PackageFactory.lookupByIdAndUser(pkg.getId(), usr);
        assertNotNull(pkg2);
        // Check to make sure it returns NULL
        // if we lookup with a User who isnt part of the
        // Org that owns that Action.  Ignore for 
        // Sat mode since there is only one Org.
    }
    
    /**
     * Add a row to the rhnServerNeedsPackageCache table
     */
    public static void updateNeedsPackageCache(Long orgId, Long serverId, 
            Long packageId) {
        WriteMode m = 
            ModeFactory.
                getWriteMode("test_queries", "insert_into_rhnServerNeededPackageCache");
        Map params = new HashMap();
        params.put("org_id", orgId);
        params.put("server_id", serverId);
        params.put("package_id", packageId);
        m.executeUpdate(params);
    }
    
    public void testLookupPackageArchByLabel() {
        assertNull(PackageFactory.lookupPackageArchByLabel("biteme-arch"));
        assertNotNull(PackageFactory.lookupPackageArchByLabel("i386"));
    }

    public void testLookupByNameAndServer() throws Exception {
        Server testServer = ServerFactoryTest.createTestServer(user, true);
        
        Channel channel = ChannelFactoryTest.createBaseChannel(user);
        testServer.addChannel(channel);
        
        Package testPackage = PackageTest.createTestPackage(user.getOrg());

        //Test a package the satellite knows about
        InstalledPackage testInstPack = new InstalledPackage();
        testInstPack.setArch(testPackage.getPackageArch());
        testInstPack.setEvr(testPackage.getPackageEvr());
        testInstPack.setName(testPackage.getPackageName());
        testInstPack.setServer(testServer);        
        Set serverPackages = new HashSet();
        serverPackages.add(testInstPack);
        testServer.setPackages(serverPackages);

        ServerFactory.save(testServer);
        testServer = (Server) reload(testServer);
        
        InstalledPackage pack = PackageFactory.lookupByNameAndServer(
                testInstPack.getName().getName(), testServer);
        
        assertEquals(testInstPack, pack);
    }
    
    public void testPackageSearch() {
        List pids = new ArrayList();
        pids.add(2125L);
        pids.add(2915L);
        String[] arches = {"channel-ia32", "channel-ia64"};
        
        List<PackageOverview> results =
            PackageFactory.packageSearch(pids, Arrays.asList(arches));
        assertNotNull(results);
    }
}

