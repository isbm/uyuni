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
package com.redhat.rhn.domain.rhnpackage.profile;

import com.redhat.rhn.domain.rhnpackage.PackageEvr;
import com.redhat.rhn.domain.rhnpackage.PackageName;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import java.io.Serializable;

/**
 * 
 * InstalledPackage
 * This class is a representation of the rhnserverpackage table
 *    it does not map directly to the rhnpackage table, because it can 
 *    contain entries that do not correspond to an entry in the rhnpackage table.
 *    This is because it a system may have a package installed that the 
 *    satellite does not have. 
 *    This object is an instance of a package that is installed on a server
 * @version $Rev$
 */
public class ProfileEntry implements Serializable {

    private PackageEvr evr;
    private PackageName name;
    private Profile profile;
    
    
    

    /**
     * @return Returns the evr.
     */
    public PackageEvr getEvr() {
        return evr;
    }
    
    /**
     * @param evrIn The evr to set.
     */
    public void setEvr(PackageEvr evrIn) {
        this.evr = evrIn;
    }
    
    /**
     * @return Returns the name.
     */
    public PackageName getName() {
        return name;
    }
    
    /**
     * @param nameIn The name to set.
     */
    public void setName(PackageName nameIn) {
        this.name = nameIn;
    }
    
    /**
     * 
     * {@inheritDoc}
     */
    public int hashCode() {
        HashCodeBuilder builder =  new HashCodeBuilder().append(name.getName())
                                    .append(evr.getEpoch())
                                    .append(evr.getRelease())
                                    .append(evr.getVersion());
                                    

        return builder.toHashCode();
                                  
    }

    /** 
     * {@inheritDoc}
     */
    public boolean equals(Object other) {
        
        if (other instanceof ProfileEntry) {
            ProfileEntry otherPack = (ProfileEntry) other;
            return new EqualsBuilder().append(this.name, otherPack.getName())
                .append(this.evr, otherPack.getEvr()).isEquals();
            
         
        }
        else {
            return false;
        }
    }

    
    /**
     * @return Returns the profile.
     */
    public Profile getProfile() {
        return profile;
    }

    
    /**
     * @param profileIn The profile to set.
     */
    public void setProfile(Profile profileIn) {
        this.profile = profileIn;
    }

    
    
}
