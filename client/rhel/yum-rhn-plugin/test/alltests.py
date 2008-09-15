#   yum-rhn-plugin - RHN support for yum
#
#   Copyright (C) 2006 Red Hat, Inc.
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#   02110-1301  USA

import unittest
import settestpath

import profilesynctests
import proxyconfigtests
import gpgkeyurltests
import sslcacertconfigtests

from unittest import TestSuite

def suite():
    # Append all test suites here:
    return TestSuite((
        profilesynctests.suite(),
        proxyconfigtests.suite(),
        gpgkeyurltests.suite(),
        sslcacertconfigtests.suite(),
    ))

if __name__ == "__main__":
    unittest.main(defaultTest="suite")
