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
package com.redhat.rhn.frontend.xmlrpc;

import java.io.InputStream;
import java.io.Writer;

import redstone.xmlrpc.XmlRpcDispatcher;
import redstone.xmlrpc.XmlRpcServer;

/**
 * RhnXmlRpcServer
 * @version $Rev$
 */
public class RhnXmlRpcServer extends XmlRpcServer {

    /**
     * Adding a method to get the callerIp into the XmlRpc for logging.
     * For some dumb reason XmlRpcServer doesn't know about callerIp
     * address unless it runs as a standalone service.
     * @param xmlInput  The XML-RPC message.
     * @param output Writer
     * @param callerIp This is supplied for informational purposes and is  made
     * available  to  custom processors.
     * @throws Throwable if the input stream contains unparseable XML or if
     * some error occurs in the SAX driver.
     */
    public void execute(InputStream xmlInput, Writer output, String callerIp)
        throws Throwable {

        XmlRpcDispatcher dispatcher = new XmlRpcDispatcher(this, callerIp);
        dispatcher.dispatch(xmlInput, output);
    }
}
