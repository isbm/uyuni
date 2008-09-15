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
package com.redhat.rhn.domain.rhnpackage;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Session;

import com.redhat.rhn.common.db.datasource.DataResult;
import com.redhat.rhn.common.db.datasource.ModeFactory;
import com.redhat.rhn.common.db.datasource.SelectMode;
import com.redhat.rhn.common.hibernate.HibernateFactory;
import com.redhat.rhn.domain.org.Org;
import com.redhat.rhn.domain.server.InstalledPackage;
import com.redhat.rhn.domain.server.Server;
import com.redhat.rhn.domain.user.User;
import com.redhat.rhn.frontend.dto.BooleanWrapper;
import com.redhat.rhn.frontend.dto.PackageOverview;
import com.redhat.rhn.manager.user.UserManager;

/**
 * PackageFactory
 * @version $Rev$
 */
public class PackageFactory extends HibernateFactory {

    private static PackageFactory singleton = new PackageFactory();
    private static Logger log = Logger.getLogger(PackageFactory.class);

    private PackageFactory() {
        super();
    }
    
    /**
     * Get the Logger for the derived class so log messages
     * show up on the correct class
     */
    protected Logger getLogger() {
        return log;
    }
    
    /**
     * Lookup a Package by its ID
     * @param id to search for
     * @return the Package found
     */
    private static Package lookupById(Long id) {
        Map params = new HashMap();
        params.put("id", id);
        return (Package)singleton.lookupObjectByNamedQuery("Package.findById", params);
    }
    
    /**
     * Returns true if the Package with the given name and evr ids exists
     * in the Channel whose id is cid.
     * @param cid Channel id to look in
     * @param nameId Package name id
     * @param evrId Package evr id
     * @return true if the Package with the given name and evr ids exists
     * in the Channel whose id is cid.
     */
    public static boolean isPackageInChannel(Long cid, Long nameId, Long evrId) {
        Map params = new HashMap();
        params.put("cid", cid);
        params.put("name_id", nameId);
        params.put("evr_id", evrId);
        SelectMode m = ModeFactory.getMode("Channel_queries",
                "is_package_in_channel");
        DataResult dr = m.execute(params);
        if (dr.isEmpty()) {
            return false;
        }
        
        BooleanWrapper bw = (BooleanWrapper) dr.get(0);
        return bw.booleanValue();
    }

    /**
     * Lookup a Package by the id, in the context of a given user.
     * Does security check to verify that the user has access to the
     * package.
     * @param id of the Package to search for
     * @param user the user doing the search
     * @return the Package found
     */
    public static Package lookupByIdAndUser(Long id, User user) {
        return lookupByIdAndOrg(id, user.getOrg());
    }
    
    /**
     * Lookup a Package by the id, in the context of a given org.
     * Does security check to verify that the org has access to the
     * package.
     * @param id of the Package to search for
     * @param org the org which much have access to the package
     * @return the Package found
     */
    public static Package lookupByIdAndOrg(Long id, Org org) {
        if (!UserManager.verifyPackageAccess(org, id)) {
            //User doesn't have access to the package... return null as if it doesn't exist.
            return null;
        }
        Package pkg = lookupById(id);
        return pkg;
    }
    
    
    /**
     * Store the package delta.
     * @param delta The object we are commiting.
     */     
   public static void save(PackageDelta delta) {
       singleton.saveObject(delta);
   }

   /**
    * Lookup a PackageArch by its label.
    * @param label package arch label sought.
    * @return the PackageArch whose label matches the given label.
    */
   public static PackageArch lookupPackageArchByLabel(String label) {
       Map params = new HashMap();
       params.put("label", label);
       return (PackageArch) singleton.lookupObjectByNamedQuery(
               "PackageArch.findByLabel", params, true);
   }

   /**
    * List the Package objects by their Package Name
    * @param pn to query by
    * @return List of Package objects if found
    */
   public static List listPackagesByPackageName(PackageName pn) {
        Session session = HibernateFactory.getSession();
        
        return session
            .getNamedQuery("Package.findByPackageName")
            .setEntity("packageName", pn)
            .list();

    }
   
   /**
    * lookup a PackageName object based on it's name, If one does not exist,
    *       create a new one and return it. 
    * @param pn the package name
    * @return a PackageName object that has a matching name
    */
   public static synchronized PackageName lookupOrCreatePackageByName(String pn) {
       PackageName returned = lookupPackageName(pn);

       if (returned == null) {
            PackageName newName = new PackageName();
            newName.setName(pn);  
            singleton.saveObject(newName);
            return newName;
       }
       else {
           return returned;
       }       
   }

    /**
    * lookup a PackageName object based on it's name,
    * returns null if it does not exist
    *        
    * @param pn the package name
    * @return a PackageName object that has a matching name or 
    *                       null if that doesn't exist
    */
    private static PackageName lookupPackageName(String pn) {
        PackageName returned =  (PackageName) HibernateFactory.getSession()
                           .getNamedQuery("PackageName.findByName")
                           .setString("name", pn)
                           .uniqueResult();
        return returned;
    }
   
   /**
    * lookup orphaned packages, i.e. packages that are not contained in any channel
    * @param org the org to check for
    * @return a List of package objects that are not in any channel
    */
   public static List lookupOrphanPackages(Org org) {
       return HibernateFactory.getSession().getNamedQuery("Package.listOrphans")
                   .setEntity("org", org).list();
   }
   
   /**
    * Find a package based off of the NEVRA
    * @param org the org that owns the package
    * @param name the name to search for
    * @param version the version to search for
    * @param release the release to search for
    * @param epoch if epoch is null, the best match for epoch will be used.   
    * @param arch the arch to search for
    * @return the requested Package
    */
   public static Package lookupByNevra(Org org, String name, String version, 
           String release, String epoch, PackageArch arch) {
           
       
       
           List<Package> packages = HibernateFactory.getSession()
                   .getNamedQuery("Package.lookupByNevra")
                   .setEntity("org", org)
                   .setString("name", name)
                   .setString("version", version)
                   .setString("release", release)
                   .setEntity("arch", arch)
                   .list();
           
           if (packages.size() == 1) {
               Package pack = packages.get(0);
               if (epoch == null || epoch.equals(pack.getPackageEvr().getEpoch())) {
                   return pack;
               }
               else {
                   return null;
               }
           }
           else {
               for (Package pack : packages) {
                   if (epoch != null && epoch.equals(pack.getPackageEvr().getEpoch())) {
                       return pack; //exact match
                   }
                   else if (epoch == null && pack.getPackageEvr().getEpoch() == null) { 
                       return pack; //exact match
                   }
               }
               return null; 
           }
   }

   /**
    * Returns an InstalledPackage object, given a server and package name 
    * to lookup  the latest version  of the package.
    *  Return null if the package doesn;t exist. 
    * @param name name of the package to lookup on 
    * @param server server where the give package was installed.
    * @return the InstalledPackage with the given 
    *               package name for the given server  
    */
   public static InstalledPackage lookupByNameAndServer(String name, Server server) {
       PackageName packName = lookupPackageName(name);
       Map params = new HashMap();
       params.put("server", server);
       params.put("name", packName);
       
       List <InstalledPackage> original = singleton.listObjectsByNamedQuery(
               "InstalledPackage.lookupByServerAndName", params);
       if (original.isEmpty()) {
           return null;
       }
       if (original.size() == 1) {
           return original.get(0);
       }
       List<InstalledPackage> packs = new LinkedList<InstalledPackage>();
       packs.addAll(original);
       Collections.sort(packs);
       return packs.get(packs.size() - 1);
   }
   
   /**
    * Lookup packages that are located in the set 'packages_to_add'  
    * @param user the user to lookup for
    * @return List of Package objects
    */
   public static List<Package> lookupPackagesFromSet(User user) {
       
       Map params = new HashMap();
       params.put("uid", user.getId());
       return  singleton.listObjectsByNamedQuery(
                       "Package.lookupFromSet", params);
       
   }
   
   /**
    * Returns PackageOverviews from a search.
    * @param pids List of package ids returned from search server.
    * @param archLabels List of channel arch labels.
    * @return PackageOverviews from a search.
    */
   public static List<PackageOverview> packageSearch(List pids, List archLabels) {
       List results = null;
       Map params = new HashMap();
       params.put("pids", pids);
       if (archLabels != null && !archLabels.isEmpty()) {
           params.put("channel_arch_labels", archLabels);
           results = singleton.listObjectsByNamedQuery(
                   "Package.searchByIdAndArches", params);
       }
       else {
           results = singleton.listObjectsByNamedQuery(
                   "Package.searchById", params);
       }
       List<PackageOverview> realResults = new ArrayList<PackageOverview>();
       for (Object result : results) {
           Object[] values = (Object[]) result;
           PackageOverview po = new PackageOverview();
           po.setId((Long)values[0]);
           po.setPackageName((String)values[1]);
           po.setSummary((String)values[2]);
           realResults.add(po);
       }

       return realResults;
   }
   
   
   
}
