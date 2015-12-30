unit BcmaOrderCom_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 5/6/2013 1:02:09 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\vista\cprs\BcmaCom\BcmaOrderCom.tlb (1)
// LIBID: {3E04F63C-8F60-447B-B3B1-A56FE9805117}
// LCID: 0
// Helpfile: 
// HelpString: BcmaOrderCom Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  BcmaOrderComMajorVersion = 1;
  BcmaOrderComMinorVersion = 0;

  LIBID_BcmaOrderCom: TGUID = '{3E04F63C-8F60-447B-B3B1-A56FE9805117}';

  IID_IBcmaOrder: TGUID = '{CA81F109-A0B1-42A6-9EAB-13E2AFBB6BA8}';
  CLASS_BcmaOrder: TGUID = '{9372B5D1-C4BB-4786-B177-0466172F0EEC}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IBcmaOrder = interface;
  IBcmaOrderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  BcmaOrder = IBcmaOrder;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; 


// *********************************************************************//
// Interface: IBcmaOrder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CA81F109-A0B1-42A6-9EAB-13E2AFBB6BA8}
// *********************************************************************//
  IBcmaOrder = interface(IDispatch)
    ['{CA81F109-A0B1-42A6-9EAB-13E2AFBB6BA8}']
    procedure InitObjects(const PatientIEN: WideString; ProviderIEN: Int64; LocationIEN: Integer); safecall;
    function ConnectToServer(const ServerName: WideString; PortNumber: Int64): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IBcmaOrderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CA81F109-A0B1-42A6-9EAB-13E2AFBB6BA8}
// *********************************************************************//
  IBcmaOrderDisp = dispinterface
    ['{CA81F109-A0B1-42A6-9EAB-13E2AFBB6BA8}']
    procedure InitObjects(const PatientIEN: WideString; ProviderIEN: {??Int64}OleVariant; 
                          LocationIEN: Integer); dispid 1;
    function ConnectToServer(const ServerName: WideString; PortNumber: {??Int64}OleVariant): WordBool; dispid 2;
  end;

// *********************************************************************//
// The Class CoBcmaOrder provides a Create and CreateRemote method to          
// create instances of the default interface IBcmaOrder exposed by              
// the CoClass BcmaOrder. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBcmaOrder = class
    class function Create: IBcmaOrder;
    class function CreateRemote(const MachineName: string): IBcmaOrder;
  end;

implementation

uses ComObj;

class function CoBcmaOrder.Create: IBcmaOrder;
begin
  Result := CreateComObject(CLASS_BcmaOrder) as IBcmaOrder;
end;

class function CoBcmaOrder.CreateRemote(const MachineName: string): IBcmaOrder;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BcmaOrder) as IBcmaOrder;
end;

end.
