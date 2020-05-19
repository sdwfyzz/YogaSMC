/*
 *  Released under "The GNU General Public License (GPL-2.0)"
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation; either version 2 of the License, or (at your
 *  option) any later version.
 *
 *  This program is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 *  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 *  for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

#ifndef WMI_h
#define WMI_h

#define kWMIGuid "guid"
#define kWMIObjectId "object-id"
#define kWMINotifyId "notify-id"
#define kWMIInstanceCount "instance-count"
#define kWMIFlags "flags"
#define kWMIFlagsText "flags-text"

#define DESC_WMI_GUID "05901221-D566-11D1-B2F0-00A0C9062910"

/*
 * If the GUID data block is marked as expensive, we must enable and
 * explicitily disable data collection.
 */

enum {
    ACPI_WMI_EXPENSIVE = 0x1,
    ACPI_WMI_METHOD    = 0x2,
    ACPI_WMI_STRING    = 0x4,
    ACPI_WMI_EVENT     = 0x8
};

class WMI
{
    IOACPIPlatformDevice* mDevice {nullptr};
    OSDictionary* mData = {nullptr};
    OSDictionary* mEvent = {nullptr};

public:
    // Constructor
    WMI(IOService *provider);
    // Destructor
    ~WMI();

    bool initialize();
    bool hasMethod(const char * guid, UInt8 flg = ACPI_WMI_METHOD);
    bool executeMethod(const char * guid, OSObject ** result = 0, OSObject * params[] = 0, IOItemCount paramCount = 0);
    bool executeinteger(const char * guid, UInt32 * result, OSObject * params[] = 0, IOItemCount paramCount = 0);
    inline IOACPIPlatformDevice* getACPIDevice() { return mDevice; }
    inline OSDictionary* getEvent() { return mEvent; }

private:
    bool extractData();
    bool extractBMF();
    void parseWDGEntry(struct WMI_DATA * block);
    
    OSDictionary* getMethod(const char * guid, UInt8 flg = 0);
    
    char * bmf_guid_string {nullptr};
};


#endif /* WMI_h */
