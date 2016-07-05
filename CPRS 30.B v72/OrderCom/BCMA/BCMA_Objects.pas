unit BCMA_Objects;
{
================================================================================
*	File:  BCMA_Objects.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 110 $  $Modtime: 5/22/02 2:16p $
*
*	Description:  This is a unit which contains global Objects developed for the
*               application.
*
================================================================================
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VHA_Objects, BCMA_Util, {Splash,} StdVcl, StdCtrls;


type
  TScanStatus = (ssInfusing,
    ssStopped,
    ssComplete,
    ssHeld,
    ssRefused,
    ssMissed,
    ssRemoved,
    ssAvailable,
    ssNotGiven,
    ssGiven,
    ssUnknown);

  TReportTypes = (rtDueList,
    rtMedicationLog,
    rtMedicationsGiven,
    rtWardAdministrationTimes,
    rtMissedMedications,
    rtPRNEffectives,                                                                                                                        
    rtMedicationVarianceLog,
    rtVitalsCumulative,
    rtPatientMedicationHistory,
    rtUnknownActions,
    rtUnableToScanDetailed,
    rtUnableToScanSummary,
    rtMedicationOverview,
    rtPRNOverview,
    rtIVOverview,
    rtExpiredOrders,
    rtMedTherapy,
    rtIVBagStatus,
    rtPatientInquiry,
    rtAllergyReactions,
    rtDisplayOrder,
    rtPatientFlags
    );

  TVDLColumnTypes = (ctScanStatus,
    ctVerifyNurse,
    ctSelfMed,
    ctScheduleType,
    ctActiveMedication,
    ctDosage,
    ctRoute,
    ctAdministrationTime,
    ctTimeLastGiven);

  sgMOColumnTypes = (MOctScheduleType,
    MOctActiveMedication,
    MOctDosage,
    MOctSchedule,
    MOctRoute,
    MOctAdministration,
    MOctTimeLastGiven,
    MOctStartDateTime);

  TMedLogTypes = (mtNone,
    mtMedPass,
    mtStatusUpdate,
    mtAddComment,
    mtPRNEffectiveness);

  TIVActionTypes = (atScan,
    atHeld,
    atRefused,
    atMissingDose);

  TOrderTypes = (otNone,
    otIV,
    otUnitDose,
    otPending);

  TScheduleTypes = (stNone,
    stContinuous,
    stPRN,
    stOneTime,
    stOnCall);

  lstPBColumnTypes = (pbScanStatus,
    pbVerifyNurse,
    pbScheduleType,
    pbActiveMedication,
    pbInfusionRate,
    pbRoute,
    pbAdministrationTime,
    pbLastAction);

  lstIVColumnTypes = (ivOrderStatus,
    ivVerifyNurse,
    ivType,
    ivActiveMedication,
    ivInfusionRate,
    ivRoute,
    ivBagInformation);

  lstBagDetailColumnTypes = (bdDateTime,
    bdNurse,
    bdAction,
    bdComment);

  lstTabs = (ctCS, ctUD, ctPB, ctIV);

  TIVHistoryStatusTypes = (iaAction1,
    iaAction2,
    iaAction3,
    iaAction4,
    iaAction5,
    iaAction6,
    iaAction7,
    iaAction8);

  lstPRNListColumnTypes = (ctPRNActiveMedication,
    ctPRNUnitsGiven,
    ctPRNAdminTime,
    ctPRNReasonGiven,
    ctPRNAdministeredBy,
    ctPRNLocation);

const
  OrderTypeCodes: array[TOrderTypes] of string[1] = ('', 'V', 'U', 'P');
  ScheduleTypeCodes: array[TScheduleTypes] of string[2] = ('',
    'C',
    'P',
    'O',
    'OC');

  ScheduleTypeTitles: array[TScheduleTypes] of string = ('',
    'Continuous',
    'PRN',
    'One-Time',
    'On-Call');

  lstUnitDoseCurrentTab: array[lstTabs] of string = ('CSTAB', 'UDTAB', 'PBTAB', 'IVTAB');
  IVHistorySortOrder: array[TIVHistoryStatusTypes] of string = ('I',
    'A',
    'N',
    'M',
    'C',
    'S',
    'H',
    'R');
  FalseTrue: array[Boolean] of string = ('False', 'True');

  ErrIncompleteData = 'Incomplete data returned from VistA';

type
  EMarkRemovedError = class(Exception)
  end;

  TBCMA_DispensedDrug = class(TObject)
    (*
      Contains information about a dispense drug.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FIEN: string;
    FName: string;
    FDose: string;
    FResultString: string;

    FQtyOrdered: string;
    FQtyScanned: integer; //this will be equivlent to the number of scans, or units scanned
    FQtyEntered: string; //This will contain the actual units given when prompted for (non TAB, CAP, PATCH)
    FQtyScannedText: string; //in the case of a fractional Dose.

    FisValidDrug: boolean;

  protected
    function getQtyOrdered: integer;

  public
    property IEN: string read FIEN;
    property Name: string read FName;
    property Dose: string read FDose;
    property ResultString: string read FResultString;

    property QtyOrderedText: string read FQtyOrdered;
    property QtyOrdered: integer read getQtyOrdered;
    property QtyScanned: integer read FQtyScanned write FQtyScanned;
    property QtyScannedText: string read FQtyScannedText write FQtyScannedText;
    property QtyEntered: string read FQtyEntered write FQtyEntered;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

  end;


  TBCMA_IVBags = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FOrderNumber,
      FUniqueID,
      FTimeLastGiven,
      FScanStatus,
      FMedLogIEN,
      FInjectionSite: string;
    FAdditives,
      FSolutions,
      FBagDetails: TStringList;
    FDisplayedMessage: Boolean;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure Clear;
    property TimeLastGiven: string read FTimeLastGiven;
    property UniqueID: string read FUniqueID write FUniqueID;
    property ScanStatus: string read FScanStatus;
    property Solutions: TStringList read FSolutions write FSolutions;
    property Additives: TStringList read FAdditives write FAdditives;
    property BagDetails: TStringList read FBagDetails;
    property OrderNumber: string read FOrderNumber;
    property InjectionSite: string read FInjectionSite;

    function GetBagDetails(StringIn: string; OrderNumIn: string): string;

  end;

  TBCMA_UserParameters = class(TObject)
    {Contains information about the User Parameters for this user.}
  private
    FRPCBroker: TBCMA_Broker;

    FDUZ,
      FDefaultPrinterName: string;
    FDefaultPrinterIEN: Integer;
    FContiniousChecked: boolean;
    FPRNChecked: boolean;
    FOneTimeChecked: boolean;
    FOnCallChecked: boolean;

    FMainFormTop: integer;
    FMainFormLeft: integer;
    FMainFormHeight: integer;
    FMainFormWidth: integer;

    FMainFormPosition: TPosition;
    FMainFormState: TWindowState;
    FCurrentTab: lstTabs;

    FUDSortColumn: TVDLColumnTypes;
    FPBSortColumn: lstPBColumnTypes;
    FIVSortColumn: lstIVColumnTypes;

    FCSMOSortColumn,
      FCSPRNSortColumn,
      FCSIVSortColumn,
      FCSExSortColumn: Integer;

    FStartTime,
      FStopTime: string;

    FChanged: boolean;

  protected
    procedure setContiniousChecked(newValue: boolean);
    procedure setPRNChecked(newValue: boolean);
    procedure setOneTimeChecked(newValue: boolean);
    procedure setOnCallChecked(newValue: boolean);

    procedure setMainFormTop(newValue: integer);
    procedure setMainFormLeft(newValue: integer);
    procedure setMainFormHeight(newValue: integer);
    procedure setMainFormWidth(newValue: integer);

    procedure setMainFormPosition(newValue: TPosition);
    procedure setMainFormState(newValue: TWindowState);
    procedure setCurrentTab(newValue: lstTabs);

    procedure setStartTime(newValue: string);
    procedure setStopTime(newValue: string);
    procedure setDefaultPrinterIEN(newValue: Integer);

    procedure setUDSortColumn(newValue: TVDLColumnTypes);
    procedure setPBSortColumn(newValue: lstPBColumnTypes);
    procedure setIVSortColumn(newValue: lstIVColumnTypes);

    procedure setFChanged(newValue: Boolean);

  public
    property DUZ: string read FDUZ;

    property ContiniousChecked: boolean read FContiniousChecked write setContiniousChecked;
    property PRNChecked: boolean read FPRNChecked write setPRNChecked;
    property OneTimeChecked: boolean read FOneTimeChecked write setOneTimeChecked;
    property OnCallChecked: boolean read FOnCallChecked write setOnCallChecked;

    property MainFormTop: integer read FMainFormTop write setMainFormTop;
    property MainFormLeft: integer read FMainFormLeft write setMainFormLeft;
    property MainFormHeight: integer read FMainFormHeight write setMainFormHeight;
    property MainFormWidth: integer read FMainFormWidth write setMainFormWidth;

    property MainFormPosition: TPosition read FMainFormPosition write setMainFormPosition;
    property MainFormState: TWindowState read FMainFormState write setMainFormState;
    property CurrentTab: lstTabs read FCurrentTab write setCurrentTab;

    property StartTime: string read FStartTime write setStartTime;
    property StopTime: string read FStopTime write setStopTime;

    property UDSortColumn: TVDLColumnTypes read FUDSortColumn write setUDSortColumn;
    property PBSortColumn: lstPBColumnTypes read FPBSortColumn write setPBSortColumn;
    property IVSortColumn: lstIVColumnTypes read FIVSortColumn write setIVSortColumn;

    property CSMOSortColumn: integer read FCSMOSortColumn write FCSMOSortColumn;
    property CSPRNSortColumn: integer read FCSPRNSortColumn write FCSPRNSortColumn;
    property CSIVSortColumn: integer read FCSIVSortColumn write FCSIVSortColumn;
    property CSExSortColumn: integer read FCSExSortColumn write FCSExSortColumn;

    property DefaultPrinterIEN: Integer read FDefaultPrinterIEN write setDefaultPrinterIEN;
    property DefaultPrinterName: string read FDefaultPrinterName write FDefaultPrinterName;
    property Changed: Boolean write SetFChanged;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil.  Calls method SaveData
      to save any changes in the User's Parameter values.
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

  end;

  TBCMA_SiteParameters = class(TObject)
    {Contains information about the Site Parameters for this site.}
  private
    FRPCBroker: TBCMA_Broker;

    //			FOnLine,
    FContinuousChecked,
      FPRNChecked,
      FOneTimeChecked,
      FOnCallChecked,
      FMedOrderButton,
      FReportInclCmt: boolean;

    FMinutesBefore,
      FMinutesAfter,
      FMinutesPRNEffect,
      FVDLStartTime,
      FVDLStopTime,
      FIdleTimeout,
      FMAHMaxDays,
      FMedHistDaysBack,
      FMaxDateRange: integer;

    FServerClockVariance,
      FMaximumServerClockVariance: integer;

    FHFSScratch,
      FHFSBackup,
      FMGSysError,
      FMGDLError,
      FMGMissingDose,
      FAutoUpdateServer,
      FMGAutoUpdate,
      FUDID,
      FIVID,
      FUNITDOSE_DIALOG,
      FIV_DIALOG: string;

    FListReasonsGivenPRN,
      FListReasonsHeld,
      FListReasonsRefused,
      FListInjectionSites,
      FListDevices,
      FWardList,
      FProviderList,
      FToolsApps: TStringList;

    FChanged: boolean;

  protected
    function getServerClockVariance: real;
    function getMaximumServerClockVariance: real;
    function GetParameter(Parameter: string; UpArrowPiece: Integer): string;
    function SetParameter(DivisionID, Parameter: string; newValue: string): Boolean;

  public
    property ContinuousChecked: boolean read FContinuousChecked;
    property PRNChecked: boolean read FPRNChecked;
    property OneTimeChecked: boolean read FOneTimeChecked;
    property OnCallChecked: boolean read FOnCallChecked;
    property MedOrderButton: boolean read FMedOrderButton write FMedOrderButton;
    property ReportInclCmt: boolean read FReportInclCmt;

    property MinutesBefore: integer read FMinutesBefore;
    property MinutesAfter: integer read FMinutesAfter;
    property MinutesPRNEffect: integer read FMinutesPRNEffect;
    property VDLStartTime: integer read FVDLStartTime;
    property VDLStopTime: integer read FVDLStopTime;
    property IdleTimeout: integer read FIdleTimeout;
    property MAHMaxDays: integer read FMAHMaxDays;
    property MedHistDaysBack: integer read FMedHistDaysBack;
    property MaxDateRange: integer read FMaxDateRange;

    property ServerClockVariance: real read getServerClockVariance;
    property MaximumServerClockVariance: real read getMaximumServerClockVariance;

    property HFSScratch: string read FHFSScratch;
    property HFSBackup: string read FHFSBackup;
    property MGSysError: string read FMGSysError;
    property MGDLError: string read FMGDLError;
    property MGMissingDose: string read FMGMissingDose;
    property AutoUpdateServer: string read FAutoUpdateServer;
    property MGAutoUpdate: string read FMGAutoUpdate;
    property UDID: string read FUDID;
    property IVID: string read FIVID;
    property UNITDOSE_DIALOG: string read FUNITDOSE_DIALOG;
    property IV_DIALOG: string read FIV_DIALOG;
    property ListReasonsGivenPRN: TStringList read FListReasonsGivenPRN;
    property ListReasonsHeld: TStringList read FListReasonsHeld;
    property ListReasonsRefused: TStringList read FListReasonsRefused;
    property ListInjectionSites: TStringList read FListInjectionSites;
    property ListDevices: TStringList read FListDevices;
    property WardList: TStringList read FWardList;
    property ProviderList: TStringList read FProviderList;
    property ToolsApps: TStringList read FToolsApps;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

  end;

  TBCMA_MedOrder = class(TObject)
    (*
      Contains information about a Medication Order for a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FPatientIEN,
      FOrderNumber,
      FOrderIEN,
      FOrderType,
      FScheduleType,
      FSchedule,
      FSelfMed,
      FActiveMedication,
      FDosage,
      FRoute,
      FTimeLastAction, //Date and time the last action occured for any action on any order that has the same orderable item
      FLastGivenDateTime,
      FMedLogIEN,
      FScanStatus,
      FAdministrationTime,
      FOrderableItemIEN,
      FAdministrationUnit,
      FLastActivityStatus,
      FVerifyNurse,
      FSpecialInstructions,
      FStartDateTime,
      FOrderStatus,
      FUniqueID,
      FNurseIEN, //this is the IEN for the nurse that took the last action
      //on this administration only.
      FOrderTransferred,
      FStopDateTime: string; //Date and Time the last action occured for this administration only

    FInjectionSiteNeeded,
      FVariableDose,
      FWardStock,
      FDisplayInstructions,
      FUnknownMessageDisplayed,
      FOrderTooTall: boolean;

    FOrderedDrugIENs,
      FOrderedDrugNames,
      FOrderedDrugUnits,
      FUnitsGiven,
      FSolutions,
      FAdditives,
      FPRNList,
      FUniqueIDs,
      FLastFourActions, //if this is a PRN, this will contain the last four actions when validated.
      FOrderChangedData,
      FAdditionalComments: TStringList;

    FOrderedDrugs: TList;

    FReasonGivenPRN,
      FUserComments,
      FUserComments2,
      FInjectionSite: string;

    FStatus: integer;
    FStatusMessage: string;
    FValidOrder: boolean;
    FAction: string; //Action user is attempting to take (we won't have this in all cases)

    FChanged: boolean;

  protected
    procedure setOrderNumber(newValue: string);
    procedure setOrderType(newValue: string);
    procedure setMedLogIEN(newValue: string);
    procedure setOrderableItemIEN(newValue: string);

    procedure setScanStatus(newValue: string);
    procedure setSelfMed(newValue: string);
    procedure setScheduleType(newValue: string);

    procedure setSchedule(newValue: string);

    procedure setActiveMedication(newValue: string);
    procedure setDosage(newValue: string);
    procedure setRoute(newValue: string);
    procedure setAdministrationTime(newValue: string);
    procedure setTimeLastAction(newValue: string);
    procedure setLastActivityStatus(newValue: string);
    procedure setSpecialInstructions(newValue: string);
    procedure setVerifyNurse(newValue: string);
    procedure setStartDateTime(newValue: string);
    procedure setOrderStatus(newValue: string);
    function getOrderTypeID: TOrderTypes;
    function getScheduleTypeID: TScheduleTypes;
    function getPRNList: TStringList;

    function getOrderedDrugs(index: integer): TBCMA_DispensedDrug;
    function getIsPatch: Boolean;

  public
    property PatientIEN: string read FPatientIEN;

    property OrderNumber: string read FOrderNumber write setOrderNumber;
    property OrderIEN: string read FOrderIEN;
    property OrderType: string read FOrderType write setOrderType;
    property OrderTypeID: TOrderTypes read getOrderTypeID;

    property ScheduleType: string read FScheduleType write setScheduleType;
    property Schedule: string read FSchedule write setSchedule;
    property ScheduleTypeID: TScheduleTypes read getScheduleTypeID;

    property SelfMed: string read FSelfMed write setSelfMed;

    property ActiveMedication: string read FActiveMedication write setActiveMedication;
    property Dosage: string read FDosage write setDosage;
    property Route: string read FRoute write setRoute;

    property TimeLastAction: string read FTimeLastAction write setTimeLastAction;
    property LastGivenDateTime: string read FLastGivenDateTime write FLastGivenDateTime;
    property LastActivityStatus: string read FLastActivityStatus write setLastActivityStatus;
    property StartDateTime: string read FStartDateTime write setStartDateTime;
    property StopDateTime: string read FStopDateTime;
    property OrderStatus: string read FOrderStatus write setOrderStatus;

    property VerifyNurse: string read FVerifyNurse write setVerifyNurse;
    property MedLogIEN: string read FMedLogIEN write setMedLogIEN;
    property ScanStatus: string read FScanStatus write setScanStatus;

    property AdministrationTime: string read FAdministrationTime write setAdministrationTime;

    property OrderableItemIEN: string read FOrderableItemIEN write setOrderableItemIEN;

    property InjectionSiteNeeded: boolean read FInjectionSiteNeeded;
    property VariableDose: boolean read FVariableDose;
    property WardStock: boolean read FWardStock write FWardStock;
    property DisplayInstructions: boolean read FDisplayInstructions;
    property OrderTooTall: boolean read FOrderTooTall write FOrderTooTall;

    property UnknownMessageDisplayed: boolean read FUnknownMessageDisplayed write FUnknownMessageDisplayed;
    property AdministrationUnit: string read FAdministrationUnit write FAdministrationUnit;

    property SpecialInstructions: string read FSpecialInstructions write setSpecialInstructions;

    property OrderedDrugs[index: integer]: TBCMA_DispensedDrug read getOrderedDrugs {write setOrderedDrugs};

    //property IVBags: TList read FIVBags { write setIVBags};

    property OrderedDrugIENs: TStringList read FOrderedDrugIENs {write setDispensedDrugName};
    property OrderedDrugNames: TStringList read FOrderedDrugNames {write setDispensedDrugName};
    property OrderedDrugUnits: TStringList read FOrderedDrugUnits {write setDispensedDrugName};
    property UnitsGiven: TStringList read FUnitsGiven {write setUnitsGiven};

    property Solutions: TStringList read FSolutions {write setSolutions};
    property Additives: TStringList read FAdditives {write setAdditives};
    property UniqueIDs: TStringList read FUniqueIDs;
    property LastFourActions: TStringList read FLastFourActions;
    property OrderChangedData: TStringList read FOrderChangedData;
    property AdditionalComments: TStringList read FAdditionalComments write FAdditionalComments;

    property ReasonGivenPRN: string read FReasonGivenPRN write FReasonGivenPRN;
    property UserComments: string read FUserComments write FUserComments;
    property UserComments2: string read FUserComments2 write FUserComments2;
    property InjectionSite: string read FInjectionSite write FInjectionSite;

    property Status: integer read FStatus;
    property StatusMessage: string read FStatusMessage;
    property Action: string read FAction write FAction;

    property PRNList: TstringList read getPRNList;
    property UniqueID: string read FUniqueID;
    property NurseIEN: string read FNurseIEN;
    property OrderTransferred: string read FOrderTransferred;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

    function indexOf(value: string): integer;
    (*
      Given an input drug IEN code, this function returns the index of the
      correponding Ordered Drug in the OrderedDrugs TList.
    *)

    function OrderedDrugCount: integer;
    (*
      Returns the value of OrderedDrugs.count.
    *)

    function SolutionCount: integer;
    (*
      Returns the value of Solutions.count.
    *)

    function AdditiveCount: integer;
    (*
      Returns the value of Additives.count.
    *)

    function UniqueIDCount: Integer;

    procedure ClearDispensedDrugsEnteredData;
    function CheckQtyEntered: Boolean;
    procedure ClearAdminInfo;
  end;

  TBCMA_Patient = class(TObject)
    (*
      Contains information about a Patient.
    *)
  private
    FRPCBroker: TBCMA_Broker;

    FIEN: string;
    FName: string;
    FSSN: string;
    FDOB: Double;
    FSex: string;
    FAge: integer;
    FWard: string;
    FWardIEN: string;
    FHospitalLocation: String;
    FHospitalLocationIEN: String;
    FRmBed: string;
    FHeight: string;
    FWeight: string;
    FICN,
      FAdminMessage: string;
    FReactions: boolean;
    FMedOrders,
      FOMMedOrders,
      FIVBags,
      FPRNEffectList,
      FGivenExpiredPatches: TList;
    FOMMedOrdersOrderID,
      FPatientRecordFlags: TStringList;

    FMeans: boolean; //Means test required
    FMeans1: string; //Means test message one
    FMeans2: string; //Means test message two
    FLocked,
      FChanged,
      FActiveUDOrders,
      FActivePBOrders,
      FActiveIVOrders,
      FTransferred: boolean;

    FAllergies,
      FADRs,
      FTransferredMovementType,
      FTransferredTransactionType: string;

  protected
    procedure SetName(newValue: string);
    procedure SetSSN(newValue: string);
    function getSSN: string;

    //procedure SetDOB(newValue: TDateTime);
    procedure SetDOB(newValue: Double);
    function GetDOB: string;
    procedure SetMDOB(newValue: string);

    procedure SetSex(newValue: string);

    function getAge: integer;

    procedure SetWard(newValue: string);
    procedure SetRmBed(newValue: string);
    procedure SetHeight(newValue: string);
    procedure SetWeight(newValue: string);
    procedure SetReactions(newValue: boolean);

    procedure SetMeans(newValue: boolean);
    procedure SetMeans1(newValue: string);
    procedure SetMeans2(newValue: string);

    procedure SetMedOrders(newValue: TList);
    procedure ClearMedOrders;
    procedure ClearIVBags;
    //    function CheckSensitive(var Status: integer; var msg: String): Boolean;
    //    function LogSensitive: Boolean;
    function GetAllergies: string;
    procedure ClearPRNEffectiveness;
    //			function 	getMedOrder: TList;

  public
    property IEN: string read FIEN {write FIEN};
    property Name: string read FName write SetName;
    property SSN: string read getSSN write SetSSN;
    //		property DOB: TDateTime read FDOB write SetDOB;
    property DOB: string read GetDOB {write SetDOB};
    property Sex: string read FSex write SetSex;

    //			property Age: integer read getAge;
    property Age: integer read FAge;
    property Ward: string read FWard write SetWard;
    property WardIEN: string read FWardIEN write FWardIEN;
    property HospitalLocation: string read FHospitalLocation;
    property HospitalLocationIEN: string read FHospitalLocationIEN;
    property RmBed: string read FRmBed write SetRmBed;
    property Height: string read FHeight write SetHeight;
    property Weight: string read FWeight write SetWeight;
    property Reactions: boolean read FReactions write SetReactions;
    property Allergies: string read FAllergies;
    property ADRs: string read FADRs;
    property TransferredTransactionType: string read FTransferredTransactionType;
    property TransferredMovementType: string read FTransferredMovementType;
    property ICN: string read FICN;
    property AdminMessage: string read FAdminMessage;
    property PatientRecordFlags: TStringList read FPatientRecordFlags;

    property Transferred: Boolean read FTransferred default False;

    property MedOrders: TList read FMedOrders { write setMedOrders};
    property PRNEffectList: TList read FPRNEffectList;
    property OMMedOrders: TList read FOMMedOrders;
    property GivenExpiredPatches: TList read FGivenExpiredPatches;
    property IVBags: TList read FIVBags;
    property Locked: boolean read FLocked;

    property Means: boolean read FMeans write SetMeans;
    property Means1: string read FMeans1 write SetMeans1;
    property Means2: string read FMeans2 write SetMeans2;
    property ActiveUDOrders: Boolean read FActiveUDOrders;
    property ActivePBOrders: Boolean read FActivePBOrders;
    property ActiveIVOrders: Boolean read FActiveIVOrders;

    property OMMedOrdersOrderID: TStringList read FOMMedOrdersOrderID write FOMMedOrdersOrderID;

    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    (*
      Allocates memory, initializes storage variables and saves a pointer
      to a global copy of the TBCMA_Broker object
    *)

    destructor Destroy; override;
    (*
      Deallocates memory and sets FRPCBroker := nil;
    *)

    procedure Clear;
    (*
      Intitalizes internal storage variables.
    *)

 //			procedure LoadPatient(newIEN: String);
    (*
      Uses RPC 'PSB GETPT' to retrieve Patient information.
    *)

    procedure InitOMMedOrder();
    function LoadIVBags(OrderNum: string): string;
    function Unlock: boolean;
    (*
      Uses RPC 'PSB LOCK' to unlock the Patient's server data.
    *)
    procedure ClearOMMedOrders();
    procedure SendOMMedOrders(OrderIDString: WideString);
    procedure CancelOMMedOrders();

    function CheckSensitive(var Status: integer; var msg: string): Boolean;
    procedure setshp(StringIn: string);
    procedure LoadGivenExpiredPatchList;
  end;

  TmDateTime = class(TObject)
    (*
      A data structure for working with M server datetime values.
    *)
  private
    FmDateTime: string;
  protected
    function getDisplayText: string;
  public
    property mDateTime: string read FmDateTime write FmDateTime;
    property DisplayText: string read getDisplayText;
  end;

  TBCMA_OMScannedMeds = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FScannedDrugIEN,
      FScannedDrugName,
      FScannedDrugType,
      FOrderableItemIEN,
      FOrderableItemName,
      FAdditiveIEN,
      FSolutionIEN,
      FVolume: string;
    FUnitsPerDose: Integer;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure Clear;
    property ScannedDrugName: string read FScannedDrugName;
    property ScannedDrugIEN: string read FScannedDrugIEN;
    property ScannedDrugType: string read FScannedDrugType;
    property OrderableItemIEN: string read FOrderableItemIEN;
    property OrderableItemName: string read FOrderableItemName;
    property AdditiveIEN: string read FAdditiveIEN;
    property SolutionIEN: string read FSolutionIEN;
    property Volume: string read FVolume;

    property UnitsPerDose: Integer read FUnitsPerDose;

    //    function isValidMedSolution(ScannedDrugIENString, OrderType: string): Boolean;

  end;

  TBCMA_OMMedOrder = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;

    FScannedMeds: Tlist;
    FProviderIEN,
      FInjectionSite,
      FAdminDateTime,
      FOrderType,
      FIVType,
      FIntSyringe,
      FSchedule: string;
    FOrderID: WideString;

  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;

    destructor Destroy; override;

    procedure ClearOrder;
    procedure ClearScannedMeds;
    function isValidProvider(var StringIn: string): string;
    function isValidMedSolution(ScannedDrugIENString, OrderTypeIn: string): Boolean;

    property ScannedMeds: TList read FScannedMeds write FScannedMeds;
    property ProviderIEN: string read FProviderIEN write FProviderIEN;
    property AdminDateTime: string read FAdminDateTime write FAdminDateTime;
    property InjectionSite: string read FInjectionSite write FInjectionSite;
    property OrderType: string read FOrderType write FOrderType;
    property IVType: string read FIVType write FIVType;
    property IntSyringe: string read FIntSyringe write FIntSyringe;
    property OrderID: WideString read FOrderID write FOrderID;
    property Schedule: string read FSchedule write FSchedule;

    procedure SendOrder(OrderIDin: string);
    procedure GetSolAddStr(var SolutionList, AdditiveList: WideString);
  end;

  TBCMA_PRNEffectList = class(TObject)

  private
    FRPCBroker: TBCMA_Broker;
    FMedLogIEN,
      FPatientLocation,
      FAdminDateTime,
      FAdministeredBy,
      FAdministeredMed,
      FPRNReason,
      FUnitsGiven,
      FSpecialInstructions,
      FOrderableItemIEN,
      FOrderNumber: string;
    FRequirePainScore: Integer;

    FDispensedDrugs,
      FAdditives,
      FSolutions: TStringList;
  protected

  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    destructor Destroy; override;
    property MedLogIEN: string read FMedLogIEN;
    property PatientLocation: string read FPatientLocation;
    property AdminDateTime: string read FAdminDateTime;
    property AdministeredBy: string read FAdministeredBy;
    property AdministeredDrug: string read FAdministeredMed;
    property PRNReason: string read FPRNReason;
    property SpecialInsructions: string read FSpecialInstructions;
    property UnitsGiven: string read FUnitsGiven;
    property OrderableItemIEN: string read FOrderableItemIEN;
    property OrderNumber: string read FOrderNumber;
    property RequirePainScore: Integer read FRequirePainScore;

    property DispensedDrugs: TStringList read FDispensedDrugs;
    property Additives: TStringList read FAdditives;
    property Solutions: TStringList read FSolutions;
    procedure Clear;

  end;

  TBCMA_EditMedLog = class(TObject)
  private
    FRPCBroker: TBCMA_Broker;
    FMLIEN,
      FPatientIEN,
      FPatientName,
      FSSN,
      FOrderableItem,
      FOrderableItemIEN,
      FBagID,
      FScanStatus,
      FOriginalScanStatus,
      FAdminDateTime,
      FMAdminDateTime,
      FInjectionSite,
      FPRNReason,
      FPRNEffectiveness,
      FScheduleType,
      FOrderStatus,
      FOrderNumber,
      FComment,
      FTab: string; //FPatchFlag, set to true if a bag is infusing or a patch is given.

    FDispensedDrugs,
      FAdditives,
      FSolutions:
    TStringList;
    FPatchBag: Boolean; //is a patch or bag currently administered or infusing?
  protected

    function getScheduleTypeID: TScheduleTypes;
    function getAdminStatusID: TScanStatus;
    function getIsPatch: Boolean;
  public
    constructor Create(RPCBroker: TBCMA_Broker); virtual;
    destructor Destroy; override;

    procedure Clear;
    property MLIEN: string read FMLIEN;
    property PatientName: string read FPatientName;
    property SSN: string read FSSN;
    property Medication: string read FOrderableItem;
    property PRNReason: string read FPRNReason write FPRNReason;
    property PRNEffectiveness: string read FPRNEffectiveness write FPRNEffectiveness;
    property AdminDateTime: string read FAdminDateTime;
    property MAdminDateTime: string read FMAdminDateTime write FMAdminDateTime;
    property ScanStatus: string read FScanStatus write FScanStatus;
    property OriginalScanStatus: string read FOriginalScanStatus;
    property ScanStatusID: TScanStatus   read getAdminStatusID;
    property AdminStatusID: TScanStatus read getAdminStatusID;
    property InjectionSite: string read FInjectionSite write FInjectionSite;
    property DispensedDrugs: TStringList read FDispensedDrugs write FDispensedDrugs;
    property Additives: TStringList read FAdditives;
    property Solutions: TStringList read FSolutions;
    property Comment: string read FComment write FComment;
    property ScheduleType: string read FScheduleType;
    property OrderNumber: string read FOrderNumber;
    property PatchBagActive: Boolean read FPatchBag;
    property Tab: string read FTab;
    property ScheduleTypeID: TScheduleTypes read getScheduleTypeID;
    property IsPatch: Boolean read getIsPatch;
    property OrderableItemIEN: string read FOrderableItemIEN;
    property BagID: string read FBagID;
    property OrderStatus: string read FOrderStatus;
  end;

  TBCMA_TimerHandler = Class(TObject)
  public
    procedure TimerEvent(Sender: TObject);
  end;


implementation

uses
  Math, MFunStr, {Debug,
  BCMA_Startup,}
  BCMA_Common,
  MultipleOrderedDrugs, {SelectReason,
  BCMA_Main,
  Report,}
  AxCtrls,
  OrderComIntf,
  uBCMA,
  uCore;
  {WardStock,
  uCCOW,
  fPtConfirmation,
  oCoverSheet;}

////////////////////////////////////////// TmDateTime Stuff

function TmDateTime.getDisplayText: string;
var
  ss: string;
begin
  result := '';
  if FmDateTime <> '' then
  begin
    ss := FmDateTime;
    result := copy(ss, rPos('.', ss) - 4, 2) + '/' +
      copy(ss, rPos('.', ss) - 2, 2) + '@' +
      copy(ss, pos('.', ss) + 1, 99) + '00000';
    result := copy(result, 1, 10);
  end;
end;

/////////////// TBCMA_Patient Object ////////////////////////

constructor TBCMA_Patient.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
  begin
    FRPCBroker := RPCBroker;
    FMedOrders := TList.Create;
    FOMMedOrders := TList.Create;
    FIVBags := TList.Create;
    FOMMedOrdersOrderID := TStringList.Create;
    FPatientRecordFlags := TStringList.Create;
    FPRNEffectList := TList.Create;
    FGivenExpiredPatches := TList.Create
  end;

  Clear;
end;

destructor TBCMA_Patient.Destroy;
begin
  (*
   if FChanged then
    if DefMessageDlg('The Patient data has been changed!'+#13#13+'Do you wish save your changes?',
           mtConfirmation, [mbYes, mbNo], 0) = idYes then
     SaveData;
  *)
  Clear;
  FMedOrders.Free;
  FOMMedOrders.Free;
  FIVBags.Free;
  FOMMedOrdersOrderID.Free;
  FPRNEffectList.Free;
  FPatientRecordFlags.Free;
  FGivenExpiredPatches.Free;
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_Patient.Clear;
begin
  if FIEN <> '' then
  begin
    //Unlock;
    ClearMedOrders;
    ClearPRNEffectiveness;
  end;

  FIEN := '';
  FName := '';
  FSSN := '';
  FDOB := 0;
  FSex := '';
  FAge := 0;
  FWard := '';
  FWardIEN := '';
  FHospitalLocation := '';
  FHospitalLocationIEN := '';
  FRmBed := '';
  FHeight := '';
  FWeight := '';
  FReactions := False;
  FMeans := False;
  FMeans1 := '';
  FMeans2 := '';
  FLocked := False;
  FAllergies := '';
  FADRs := '';
  FTransferredMovementType := '';
  FTransferredTransactionType := '';
  FTransferred := False;
  FICN := '';
  FAdminMessage := '';
  FChanged := False;
  FPatientRecordFlags.Clear;
  FActivePBOrders := False;
end;

procedure TBCMA_Patient.SetName(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FName then
    begin
      FName := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetSSN(newValue: string);
var
  ss: string;
begin
  ss := newValue;
  while pos('-', ss) > 0 do
    ss := copy(ss, 1, pos('-', ss) - 1) + copy(ss, pos('-', ss) + 1, 99);

  if FRPCBroker <> nil then
    if ss <> FSSN then
    begin
      FSSN := ss;
      FChanged := True;
    end;
end;

function TBCMA_Patient.getSSN: string;
begin
  result := '';
  if FRPCBroker <> nil then
    if FSSN <> '' then
      result := copy(FSSN, 1, 3) + '-' + copy(FSSN, 4, 2) + '-' + copy(FSSN, 6, 4);
end;

procedure TBCMA_Patient.SetDOB(newValue: Double);
//procedure TBCMA_Patient.SetDOB(newValue: TDateTime);
begin
  if FRPCBroker <> nil then
    if newValue <> FDOB then
    begin
      FDOB := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.GetDOB: string;
begin
  try
    //if we have a valid date, let Delphi handle the date format according
    //to user's regional settings
    result := DateToStr(FMDateTimeToDateTime(FDOB))
  except
    //if not a valid date, attempt to piece the date together according to the
    //user's regional settings
    result := FormatFMDateTime(FormatSettings.shortdateformat, FDOB);
  end;
end;

procedure TBCMA_Patient.SetMDOB(newValue: string);
var
  //	tempDate:		TDateTime;
  tempDate: Double;
begin

  if FRPCBroker <> nil then
  begin
    {tempDate := strToDate(copy(newValue, 4, 2) + DateSeparator +
               copy(newValue, 6, 2) + DateSeparator +
               intToStr(strToInt(copy(newValue, 1, 3))+1700));
       }
    tempDate := MakeFMDateTime(newValue);

    if tempDate <> FDOB then
    begin
      FDOB := tempDate;
      FChanged := True;
    end;
  end;
end;

procedure TBCMA_Patient.SetSex(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSex then
    begin
      FSex := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.getAge: integer;
var
  y2, y1,
    m2, m1,
    d2, d1: word;
begin

  result := 0;
  if FRPCBroker <> nil then
  begin
    if FDOB > 0 then
    begin
      decodeDate(date, y2, m2, d2);
      decodeDate(FDOB, y1, m1, d1);
      result := y2 - y1;
      if m2 < m1 then
        result := result - 1
      else if d2 < d1 then
        result := result - 1;
    end;
  end;
end;

procedure TBCMA_Patient.SetWard(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FWard then
    begin
      FWard := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetRmBed(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRmBed then
    begin
      FRmBed := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetHeight(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FHeight then
    begin
      FHeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetWeight(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FWeight then
    begin
      FWeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetReactions(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FReactions then
    begin
      FReactions := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMedOrders(newValue: TList);
var
  ii: integer;
begin
  if FRPCBroker <> nil then
    if newValue <> nil then
    begin
      ClearMedOrders;
      for ii := 0 to newValue.count - 1 do
        FMedOrders.add(newValue.items[ii]);

      FChanged := True;
    end;
end;

procedure TBCMA_Patient.ClearMedOrders;
var
  ii: integer;
begin
  if FMedOrders <> nil then
    with FMedOrders do
    begin
      for ii := count - 1 downto 0 do
        TBCMA_MedOrder(items[ii]).free;
      clear;
    end;
  FGivenExpiredPatches.Clear;
end;

procedure TBCMA_Patient.ClearIVBags;
var
  ii: integer;
begin
  if FIVBags <> nil then
    with FIVBags do
    begin
      for ii := count - 1 downto 0 do
        TBCMA_IVBags(items[ii]).free;
      clear;
    end;

end;

function TBCMA_Patient.Unlock: boolean;
begin
  FLocked := False;
  if (FRPCBroker <> nil) and (FIEN <> '') then
    with FRPCBroker do
      if CallServer('PSB LOCK', [FIEN, '-1'], nil) then (* 1 to Lock, -1 to Unlock *)
      begin
        FLocked := not (piece(Results[0], '^', 1) = '1'); (* -1 = failure, 1 = success *)
        if FLocked then
          DefMessageDlg(piece(Results[0], '^', 2), mtError, [mbOK], 0);
      end;

  result := not FLocked;
end;

procedure TBCMA_Patient.SetMeans(newValue: Boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans then
    begin
      FMeans := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMeans1(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans1 then
    begin
      FMeans1 := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_Patient.SetMeans2(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMeans2 then
    begin
      FMeans2 := newValue;
      FChanged := True;
    end;
end;

function TBCMA_Patient.CheckSensitive(var Status: integer; var msg: string): Boolean;
begin
  Result := False;
  if FRPCBroker <> nil then
    with FRPCBroker do
    begin
      if CallServer('DG SENSITIVE RECORD ACCESS', [FIEN], nil) then
      begin
        if (Results.Count = 0) or (StrToIntDef(Results[0], -1) = -1) then
        begin
          Msg := Msg + #13 + 'Sensitive Record Check Failed!';
          Status := -1;
        end
        else
        begin
          Status := StrToIntDef(Results[0], -1);
          Results.Delete(0);
          if Results.Count > 0 then msg := Results.Text;
        end;
      end;
    end;
end;

function TBCMA_Patient.GetAllergies: string;
var
  x: integer;
  Allergies,
    ADR: string;
begin
  if FRPCBroker <> nil then
    with FRPCBroker do
    begin
      if CallServer('PSB ALLERGY', [FIEN], nil) then
        if StrToInt(results[0]) <> results.count - 1 then
          Result := 'Error in Data'
        else if piece(results[1], '^', 1) = '-1' then
        begin
          FAllergies := piece(results[1], '^', 2);
          FADRs := piece(results[1], '^', 2);
        end
        else if piece(results[1], '^', 1) = '0' then
        begin
          FAllergies := 'No allergies on file';
          FADRs := 'No ADRs on file';
        end
        else
        begin
          for x := 1 to Results.count - 1 do
            if piece(results[x], '^', 1) = 'ALL' then
            begin
              if allergies = '' then allergies := piece(results[x], '^', 2)
              else allergies := allergies + ', ' + piece(results[x], '^', 2);
            end
            else
              if piece(results[x], '^', 1) = 'ADR' then
              begin
                if adr = '' then adr := piece(results[x], '^', 2)
                else adr := adr + ', ' + piece(results[x], '^', 2);
              end;

          allergies := LowerCase(allergies);
          adr := LowerCase(adr);

          if allergies = '' then allergies := 'No allergies on file';
          if adr = '' then adr := 'No ADRs on file';

          FAllergies := Allergies;
          FADRs := ADR;
        end
      else
        FAllergies := 'Error obtaining allergy information.';
    end;
end;

///////////////////////////// TBCMA_MedOrder

procedure TBCMA_Patient.InitOMMedOrder();
begin
  with FOMMedOrders do
    add(TBCMA_OMMedOrder.Create(FRPCBroker));
end;

procedure TBCMA_Patient.LoadGivenExpiredPatchList;
var
  x: integer;
begin
  with BCMA_Patient do
  begin
    FGivenExpiredPatches.Clear;
    for x := 0 to MedOrders.Count - 1 do
      with TBCMA_MedOrder(MedOrders[x]) do
        if ((FOrderStatus = 'D') or (FOrderStatus = 'E') or (FOrderStatus = 'DE')) and GetIsPatch  and
          (FScanStatus = 'G') and (ScheduleTypeID <> stOneTime) then
          FGivenExpiredPatches.Add(TBCMA_MedOrder(FMedOrders[x]));
  end;
end;

function TBCMA_Patient.LoadIVBags(OrderNum: string): string;
var
  ii: integer;
  rr: string;
begin
  ClearIVBags;
  if (FRPCBroker <> nil) and
    (FMedOrders <> nil) and
    (FIEN <> '') then
    with FRPCBroker do
      if CallServer('PSB IV ORDER HISTORY', [FIEN, OrderNum], nil) then
        if (results.Count > 0) and
          (piece(Results[1], '^', 1) = '-1') then
        begin
          ClearIVBags;
          Result := Results[1];
        end
        else
          with FIVBags do
          begin
            Result := '1';
            ClearIVBags;
            ii := 1;
            while ii < results.Count - 1 do
            begin
              if Results[ii] = 'END' then
              begin
                break;
                ii := ii + 1;
              end;

              add(TBCMA_IVBags.create(FRPCBroker));
              with TBCMA_IVBags(FIVBags[FIVBags.count - 1]) do
              begin
                rr := Results[ii];

                FOrderNumber := piece(rr, '^', 1);
                FUniqueID := piece(rr, '^', 2);
                FMedLogIEN := piece(rr, '^', 3);
                FTimeLastGiven := piece(rr, '^', 4);
                if Pos('.', FTimeLastGiven) = 0 then
                  FTimeLastGiven := FTimeLastGiven + '.';

                FScanStatus := piece(rr, '^', 5);
                FInjectionSite := piece(rr, '^', 6);

                ii := ii + 1;
                while ii < results.Count - 1 do
                begin
                  rr := Results[ii];

                  if rr = 'END' then
                  begin
                    ii := ii + 1;
                    Break;
                  end;

                  //Solution
                  if piece(rr, '^', 1) = 'SOL' then
                  begin
                    with FSolutions do
                      add(rr);
                    {add(piece(rr, '^', 2) + '^' +
                      piece(rr, '^', 3) + '^' +
                      piece(rr, '^', 4) + '^' +
                      piece(rr, '^', 5));
                    }
                  end

                    //Additive
                  else if piece(rr, '^', 1) = 'ADD' then
                  begin
                    with FAdditives do
                      add(rr);
                    {  add(piece(rr, '^', 2) + '^' +
                        piece(rr, '^', 3) + '^' +
                        piece(rr, '^', 4) + '^' +
                        piece(rr, '^', 5));
                    }
                  end;

                  ii := ii + 1;
                end;
              end;
            end;
          end;
end;

procedure TBCMA_Patient.ClearPRNEffectiveness;
var
  ii: integer;
begin
  if FPRNEffectList <> nil then
    with FPRNEffectList do
    begin
      for ii := count - 1 downto 0 do
        TBCMA_PRNEffectList(items[ii]).free;
      clear;
    end;
end;

constructor TBCMA_MedOrder.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FOrderedDrugs := TList.Create;

  FOrderedDrugIENs := TStringList.Create;
  FOrderedDrugNames := TStringList.Create;
  FOrderedDrugUnits := TStringList.Create;

  FUnitsGiven := TStringList.Create;

  FSolutions := TStringList.Create;
  FAdditives := TStringList.Create;
  FUniqueIDs := TStringList.Create;
  FLastFourActions := TStringList.Create;
  FOrderChangedData := TStringList.Create;
  FAdditionalComments := TStringList.Create;

  FPRNList := TStringList.create;
  FPRNList.Sorted := True;

  Clear;
end;

destructor TBCMA_MedOrder.Destroy;
begin
  //	SaveData;
  FOrderedDrugs.free;

  FOrderedDrugIENs.free;
  FOrderedDrugNames.free;
  FOrderedDrugUnits.free;

  FUnitsGiven.free;

  FSolutions.free;
  FAdditives.free;
  FUniqueIDs.Free;

  FPRNList.free;
  FLastFourActions.free;
  FOrderChangedData.free;
  FAdditionalComments.free;

  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_MedOrder.Clear;
var
  ii: integer;
begin
  FPatientIEN := '';
  FMedLogIEN := '';
  FOrderableItemIEN := '';

  FScanStatus := '';
  FSelfMed := '';
  FScheduleType := '';

  FSchedule := '';

  FActiveMedication := '';
  FDosage := '';
  FRoute := '';

  FOrderNumber := '';
  FOrderIEN := '';
  FOrderType := '';

  FAdministrationTime := '';
  FTimeLastAction := '';
  FLastGivenDateTime := '';

  FInjectionSiteNeeded := False;
  FVariableDose := False;
  FWardStock := False;
  FDisplayInstructions := False;
  FUnknownMessageDisplayed := False;

  FAdministrationUnit := '';
  FLastActivityStatus := '';
  FSpecialInstructions := '';
  FVerifyNurse := '';
  FStartDateTime := '';
  FStopDateTime := '';
  FOrderStatus := '';
  FUniqueID := '';
  FAction := '';
  FNurseIEN := '';
  FOrderTransferred := '';

  with FOrderedDrugs do
    for ii := count - 1 downto 0 do
      TBCMA_DispensedDrug(items[ii]).free;

  FOrderedDrugs.clear;

  FOrderedDrugIENs.clear;
  FOrderedDrugNames.clear;
  FOrderedDrugUnits.clear;

  FUnitsGiven.Clear;

  FSolutions.clear;
  FAdditives.clear;
  FUniqueIDs.Clear;
  FPRNList.clear;
  FLastFourActions.Clear;
  FOrderChangedData.Clear;
  FAdditionalComments.Clear;

  FReasonGivenPRN := '';
  FUserComments := '';
  FUserComments2 := '';
  FInjectionSite := '';

  FStatus := -1;
  FStatusMessage := '';
  FValidOrder := False;

  FChanged := False;
end;

procedure TBCMA_MedOrder.ClearAdminInfo;
begin
  ClearDispensedDrugsEnteredData;
  FUserComments := '';
  FUserComments2 := '';
  FAdditionalComments.Clear;
end;

function TBCMA_MedOrder.getPRNList: TstringList;
var
  ii: integer;
begin
  with FRPCBroker do
    if CallServer('PSB GETPRNS', [FPatientIEN, FOrderNumber], nil) then
      if piece(results[0], '^', 1) = '-1' then
        DefMessageDlg(piece(results[0], '^', 2), mtError, [mbOK], 0)
      else
      begin
        FPRNList.clear;
        with FPRNList do
          for ii := 1 to strToInt(results[0]) do
            add(
              piece(results[ii], '^', 1) + '^' +
              piece(results[ii], '^', 2) + '^' +
              piece(results[ii], '^', 3) + '^' +
              piece(results[ii], '^', 4) + '^' +
              piece(results[ii], '^', 5) + '^' +
              piece(results[ii], '^', 6) + '^' +
              piece(results[ii], '^', 8)
              );
      end;

  result := FPRNList;
end;

function TBCMA_MedOrder.getOrderedDrugs(index: integer): TBCMA_DispensedDrug;
begin
  if (index > -1) and (index < FOrderedDrugs.count) then
    result := FOrderedDrugs.items[index]
  else
    result := nil;
end;

function TBCMA_MedOrder.indexOf(value: string): integer;
var
  ii: integer;
begin
  result := -1;
  for ii := 0 to FOrderedDrugIENs.count - 1 do
    if FOrderedDrugIENs[ii] = value then
    begin
      result := ii;
      break;
    end;
end;

function TBCMA_MedOrder.OrderedDrugCount: integer;
begin
  result := FOrderedDrugs.count;
end;

function TBCMA_MedOrder.SolutionCount: integer;
begin
  result := FSolutions.count;
end;

function TBCMA_MedOrder.AdditiveCount: integer;
begin
  result := FAdditives.count;
end;

function TBCMA_MedOrder.UniqueIDCount: integer;
begin
  Result := FUniqueIDs.Count;
end;

procedure TBCMA_MedOrder.setOrderNumber(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderNumber then
    begin
      FOrderNumber := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderType(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderType then
    begin
      FOrderType := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getOrderTypeID: TOrderTypes;
var
  id: TOrderTypes;
begin
  result := otNone;
  if (FRPCBroker <> nil) then
    for id := low(OrderTypeCodes) to high(OrderTypeCodes) do
      if String(OrderTypeCodes[id]) = FOrderType then
      begin
        result := id;
        break;
      end;
end;

procedure TBCMA_MedOrder.setMedLogIEN(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FMedLogIEN then
    begin
      FMedLogIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderableItemIEN(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderableItemIEN then
    begin
      FOrderableItemIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setScanStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FScanStatus then
    begin
      FScanStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setSelfMed(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSelfMed then
    begin
      FSelfMed := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setScheduleType(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FScheduleType then
    begin
      FScheduleType := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getScheduleTypeID: TScheduleTypes;
var
  id: TScheduleTypes;
begin
  result := stNone;
  if FRPCBroker <> nil then
    for id := low(ScheduleTypeCodes) to high(ScheduleTypeCodes) do
      if String(ScheduleTypeCodes[id]) = FScheduleType then
      begin
        result := id;
        break;
      end;
end;

procedure TBCMA_MedOrder.setSchedule(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSchedule then
    begin
      FSchedule := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setActiveMedication(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FActiveMedication then
    begin
      FActiveMedication := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setDosage(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FDosage then
    begin
      FDosage := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setRoute(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FRoute then
    begin
      FRoute := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setAdministrationTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FAdministrationTime then
    begin
      FAdministrationTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setTimeLastAction(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FTimeLastAction then
    begin
      FTimeLastAction := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setLastActivityStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FLastActivityStatus then
    begin
      FLastActivityStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setStartDateTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStartDateTime then
    begin
      FStartDateTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setOrderStatus(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FOrderStatus then
    begin
      FOrderStatus := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setVerifyNurse(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FVerifyNurse then
    begin
      FVerifyNurse := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_MedOrder.setSpecialInstructions(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FSpecialInstructions then
    begin
      FSpecialInstructions := newValue;
      FChanged := True;
    end;
end;

function TBCMA_MedOrder.getIsPatch: Boolean;
begin
  result := false;
  if FAdministrationUnit = 'PATCH' then
    result := true;
end;

procedure TBCMA_MedOrder.ClearDispensedDrugsEnteredData;
var
  ii: integer;
begin
  for ii := 0 to OrderedDrugCount - 1 do
  begin
    OrderedDrugs[ii].QtyEntered := '';
    OrderedDrugs[ii].QtyScanned := 0;
    OrderedDrugs[ii].QtyScannedText := '';
  end;
end;

function TBCMA_MedOrder.CheckQtyEntered: Boolean;
var
  ii: integer;
begin
  result := True;
  for ii := 0 to OrderedDrugCount - 1 do
    if TrimLeft(OrderedDrugs[ii].QtyEntered) = '' then
    begin
      result := False;
      exit;
    end;
end;

///////////////////////////// TBCMA_DispensedDrug

constructor TBCMA_DispensedDrug.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  clear;
end;

destructor TBCMA_DispensedDrug.Destroy;
begin
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_DispensedDrug.Clear;
begin
  FIEN := '';
  FName := '';
  FDose := '';
  FResultString := '';

  FQtyOrdered := '';
  FQtyScanned := 0;
  FQtyEntered := '';
  FisValidDrug := False;
  FQtyScannedText := '';
end;

function TBCMA_DispensedDrug.getQtyOrdered: integer;
var
  rValue: real;
begin
  rValue := strToFloat(FQtyOrdered);
  result := trunc(rValue);
  if (rValue - result) > 0 then
    inc(result);

end;

///////////////////////////// TBCMA_UserParameters

constructor TBCMA_UserParameters.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  Clear;
end;

destructor TBCMA_UserParameters.destroy;
begin
  FRPCBroker := nil;

  inherited destroy;
end;

procedure TBCMA_UserParameters.Clear;
begin
  FDUZ := '';

  FContiniousChecked := False;
  FPRNChecked := False;
  FOneTimeChecked := False;
  FOnCallChecked := False;

  FMainFormTop := 0;
  FMainFormLeft := 0;
  FMainFormHeight := 600;
  FMainFormWidth := 800;

  FMainFormPosition := poDesktopCenter;
  FMainFormState := wsNormal;

  FUDSortColumn := ctActiveMedication;
  FPBSortColumn := PBActiveMedication;
  FIVSortColumn := IVActiveMedication;
  FChanged := False;
end;

procedure TBCMA_UserParameters.setContiniousChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FContiniousChecked then
    begin
      FContiniousChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setPRNChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FPRNChecked then
    begin
      FPRNChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setOneTimeChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FOneTimeChecked then
    begin
      FOneTimeChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setOnCallChecked(newValue: boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FOnCallChecked then
    begin
      FOnCallChecked := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormTop(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormTop then
    begin
      FMainFormTop := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormLeft(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormLeft then
    begin
      FMainFormLeft := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormHeight(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormHeight then
    begin
      FMainFormHeight := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormWidth(newValue: integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormWidth then
    begin
      FMainFormWidth := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormPosition(newValue: TPosition);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormPosition then
    begin
      FMainFormPosition := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setMainFormState(newValue: TWindowState);
begin
  if FRPCBroker <> nil then
    if newValue <> FMainFormState then
    begin
      FMainFormState := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setCurrentTab(newValue: lstTabs);
begin
  if FRPCBroker <> nil then
    if newValue <> FCurrentTab then
    begin
      FCurrentTab := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setStartTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStartTime then
    begin
      FStartTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setStopTime(newValue: string);
begin
  if FRPCBroker <> nil then
    if newValue <> FStopTime then
    begin
      FStopTime := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setUDSortColumn(newValue: TVDLColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FUDSortColumn then
    begin
      FUDSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setPBSortColumn(newValue: lstPBColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FPBSortColumn then
    begin
      FPBSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setIVSortColumn(newValue: lstIVColumnTypes);
begin
  if FRPCBroker <> nil then
    if newValue <> FIVSortColumn then
    begin
      FIVSortColumn := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setDefaultPrinterIEN(newValue: Integer);
begin
  if FRPCBroker <> nil then
    if newValue <> FDefaultPrinterIEN then
    begin
      FDefaultPrinterIEN := newValue;
      FChanged := True;
    end;
end;

procedure TBCMA_UserParameters.setFChanged(newvalue: Boolean);
begin
  if FRPCBroker <> nil then
    if newValue <> FChanged then
    begin
      FChanged := newValue;
    end;
end;

///////////////////////////// TBCMA_SiteParameters

constructor TBCMA_SiteParameters.create(RPCBroker: TBCMA_Broker);
begin
  inherited create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FListReasonsGivenPRN := TStringList.Create;
  FListReasonsHeld := TStringList.Create;
  FListReasonsRefused := TStringList.create;
  FListInjectionSites := TStringList.create;
  FListDevices := TStringList.Create;
  FWardList := TStringList.Create;
  FProviderList := TStringList.Create;
  FToolsApps := TStringList.Create;
  Clear;
end;

destructor TBCMA_SiteParameters.destroy;
begin
  //	SaveData;

  FListReasonsGivenPRN.Free;
  FListReasonsHeld.Free;
  FListReasonsRefused.Free;
  FListInjectionSites.Free;
  FListDevices.Free;
  FWardList.Free;
  FProviderList.Free;
  FToolsApps.Free;
  FRPCBroker := nil;

  inherited destroy;
end;

procedure TBCMA_SiteParameters.Clear;
begin
  FContinuousChecked := False;
  FPRNChecked := False;
  FOneTimeChecked := False;
  FOnCallChecked := False;
  FMedOrderButton := False;
  FReportInclCmt := False;

  FMinutesBefore := 0;
  FMinutesAfter := 0;
  FMinutesPRNEffect := 0;
  FVDLStartTime := 0;
  FVDLStopTime := 0;
  FIdleTimeout := 0;
  FMAHMaxDays := 0;
  FMedHistDaysBack := 0;
  FMaxDateRange := 0;

  FServerClockVariance := 0;
  FMaximumServerClockVariance := 0;

  FHFSScratch := '';
  FHFSBackup := '';
  FMGSysError := '';
  FMGDLError := '';
  FMGMissingDose := '';
  FAutoUpdateServer := '';
  FMGAutoUpdate := '';
  FUDID := '';
  FIVID := '';
  FUNITDOSE_DIALOG := '';
  FIV_DIALOG := '';

  FListReasonsGivenPRN.Clear;
  FListReasonsHeld.Clear;
  FListReasonsRefused.Clear;
  FListInjectionSites.clear;
  FListDevices.Clear;
  FWardList.Clear;
  FProviderList.Clear;

  FChanged := False;
end;

function TBCMA_SiteParameters.getServerClockVariance: real;
begin
  result := 0.0;
  if FRPCBroker <> nil then
    result := FServerClockVariance / 1440;
end;

function TBCMA_SiteParameters.getMaximumServerClockVariance: real;
begin
  result := 0.0;
  if FRPCBroker <> nil then
    result := FMaximumServerClockVariance / 1440;
end;

function TBCMA_SiteParameters.GetParameter(Parameter: string; UpArrowPiece: Integer): string;
begin
  Result := '';
  with FRPCBroker do
    //		if CallServer('PSB PARAMETER',['GETPAR',FDivisionID,Parameter],nil) then
    if CallServer('PSB PARAMETER', ['GETPAR', 'ALL', Parameter], nil) then
      Result := piece(Results[0], '^', UpArrowPiece);
end;

function TBCMA_SiteParameters.SetParameter(DivisionID, Parameter: string; newValue: string): Boolean;
begin
  Result := False;
  //	if UpdateMode then
    //DefMessageDlg('Update Parameter ' + Parameter + ' to ' + newValue,mtInformation,[mbyes,mbno],0);
  with FRPCBroker do
    if CallServer('PSB PARAMETER', ['SETPAR', DivisionID, Parameter, '1', newValue], nil) then
      if piece(Results[0], '^', 1) = '-1' then
        DefMessageDlg('Invalid Parameter Value', mtError, [mbok], 0)
      else
        Result := True;
end;

constructor TBCMA_IVBags.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;

  FSolutions := TStringList.Create;
  FAdditives := TStringList.Create;
  FBagDetails := TStringList.Create;
  Clear;

end;

destructor TBCMA_IVBags.Destroy;
begin

  FSolutions.Free;
  FAdditives.Free;
  FBagDetails.Free;
  FRPCBroker := nil;

  inherited Destroy;

end;

procedure TBCMA_IVBags.Clear;

begin
  FOrderNumber := '';
  FUniqueID := '';
  FTimeLastGiven := '';
  FScanStatus := '';
  FMedLogIEN := '';
  FInjectionSite := '';

  FSolutions.Clear;
  FAdditives.Clear;
  FBagDetails.Clear;

  FDisplayedMessage := False;

end;

function TBCMA_IVBags.GetBagDetails(StringIn: string; OrderNumIn: string): string;
var
  x: integer;
begin
  FBagDetails.Clear;
  if (FRPCBroker <> nil) then
    with FRPCBroker do
      if CallServer('PSB BAG DETAIL', [StringIn, OrderNumIn], nil) then
        if (Results.Count = 0) or (Results.Count - 1 <> StrToIntDef(Results[0], -1)) then
        begin
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
          exit;
        end
        else if piece(Results[1], '^', 1) = '-1' then
          Result := Results[1]
        else
        begin
          for x := 1 to Results.Count - 1 do
            FBagDetails.Add(Results[x]);
          Result := '1';
        end;

end;


function TBCMA_OMMedOrder.isValidMedSolution(ScannedDrugIENString, OrderTypeIn: string): boolean;
var
  ii, jj: integer;

  function AddDrug(StringIn: string): Boolean;
  var
    x: integer;
  begin
    Result := True;
    with TBCMA_OMMedOrder(OMMedOrders[OMMedOrders.count - 1]) do
      with FScannedMeds do
      begin
        if OrderTypeIn = 'UD' then
        begin
          if FScannedMeds.Count > 0 then
            if TBCMA_OMScannedMeds(FScannedMeds[0]).FOrderableItemIEN <> Piece(StringIn, '^', 6) then
            begin
              DefMessageDlg('Scanned medication must have the same orderable item as the first scanned Medication!', mtError, [mbOK], 0);
              Result := False;
              exit;
            end;

          for x := 0 to FScannedMeds.count - 1 do
            if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugIEN = Piece(StringIn, '^', 2) then
            begin
              TBCMA_OMScannedMeds(FScannedMeds[x]).FUnitsPerDose := TBCMA_OMScannedMeds(FScannedMeds[x]).FUnitsPerDose + 1;
              exit;
            end;
        end;

        add(TBCMA_OMScannedMeds.create(FRPCBroker));
        with TBCMA_OMScannedMeds(FScannedMeds[FScannedMeds.count - 1]) do
        begin
          FScannedDrugType := Piece(StringIn, '^', 1);
          FOrderableItemIEN := Piece(StringIn, '^', 6);
          FOrderableItemName := Piece(StringIn, '^', 7);
          FScannedDrugIEN := Piece(StringIn, '^', 2);
          //FScannedDrugName := Piece(StringIn, '^', 3);
          FUnitsPerDose := 1;

          if ScannedDrugType = 'ADD' then
          begin
            FAdditiveIEN := Piece(StringIn, '^', 8);
            FScannedDrugName := piece(StringIn, '^', 9) + ' ' + piece(StringIn, '^', 10);
          end
          else if ScannedDrugType = 'SOL' then
          begin
            FSolutionIEN := Piece(StringIn, '^', 8);
            FScannedDrugName := piece(StringIn, '^', 9) + ' ' + piece(StringIn, '^', 10);
          end
          else if ScannedDrugType = 'DD' then
            FScannedDrugName := Piece(StringIn, '^', 3);

          FVolume := Piece(StringIn, '^', 10);
        end;
      end;
  end;

begin
  result := False;
  if BCMA_Broker <> nil then
    with BCMA_Broker do
      if CallServer('PSB MOB DRUG LIST', [ScannedDrugIENString, OrderTypeIn], nil) then
        with TfrmMultipleOrderedDrugs.create(application) do
          if Results.Count - 1 <> StrToInt(Results[0]) then
          begin
            DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0);
            //showmessage(inttostr(results.count) + ' ' + results[0] + ' ' + results[1]);
          end
          else if piece(Results[1], '^', 1) = '-1' then
            DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
          else if piece(Results[1], '^', 1) = '-2' then
            DefMessageDlg('Too many results returned!' + #13 + 'Please enter more criteria.', mtInformation, [mbOK], 0)
          else if StrToInt(Results[0]) = 1 then
          begin
            Result := AddDrug(Results[1]);
            //Result := True;
          end
          else if StrToInt(Results[0]) > 1 then
          begin
            with TfrmMultipleOrderedDrugs.create(application) do
            try
              for ii := 1 to Results.Count - 1 do
                if OrderTypeIn = 'UD' then
                  lbxSelectList.items.addObject(piece(Results[ii], '^', 3), ptr(ii))
                else
                  lbxSelectList.items.addObject(piece(Results[ii], '^', 9) + ' ' + piece(Results[ii], '^', 10), ptr(ii));
              ii := showModal;
              if ii <> mrCancel then
              begin
                jj := ii - 100;
                Result := AddDrug(Results[jj]);
                //Result := True;
              end;
            finally
              free;
            end;
          end
          else
            Result := False;
end;

function TBCMA_OMMedOrder.isValidProvider(var StringIn: string): string;
var
  ii, jj: Integer;
begin
  Result := '-1';
  if BCMA_Broker <> nil then
    with BCMA_Broker do
      if CallServer('PSB GETPROVIDER', [StringIn], nil) then
        if Results.Count - 1 <> StrToInt(Results[0]) then
          DefMessageDlg(ErrIncompleteData, mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-1' then
          DefMessageDlg(piece(Results[1], '^', 2), mtError, [mbOK], 0)
        else if piece(Results[1], '^', 1) = '-2' then
          DefMessageDlg('Please narrow down your search!', mtInformation, [mbOK], 0)
        else if StrToInt(Results[0]) > 1 then
        begin
          with TfrmMultipleOrderedDrugs.create(application) do
          try
            caption := 'Provider';
            Repaint;
            Label1.Caption := 'Please select a provider:';
            for ii := 1 to Results.Count - 1 do
              lbxSelectList.items.addObject(piece(Results[ii], '^', 2), ptr(ii));
            ii := showModal;
            if ii <> mrCancel then
            begin
              jj := ii - 100;
              //showmessage(piece(Results[jj], '^', 2));
              StringIn := piece(Results[jj], '^', 2);
              Result := piece(Results[jj], '^', 1);
            end;
          finally
            free;
          end;

        end
        else
        begin
          StringIn := piece(Results[1], '^', 2);
          Result := piece(Results[1], '^', 1);
        end;
end;

constructor TBCMA_OMScannedMeds.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if RPCBroker <> nil then
  begin
    FRPCBroker := RPCBroker;
    //FMedOrders := TList.Create;
    //FIVBags := TList.Create;
  end;

  Clear;
end;

destructor TBCMA_OMScannedMeds.Destroy;
begin
  (*
   if FChanged then
    if DefMessageDlg('The Patient data has been changed!'+#13#13+'Do you wish save your changes?',
           mtConfirmation, [mbYes, mbNo], 0) = idYes then
     SaveData;
  *)
  Clear;
  //FMedOrders.Free;
  //FIVBags.Free;

  FRPCBroker := nil;

  inherited Destroy;
end;

constructor TBCMA_OMMedOrder.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;

  if BCMA_Broker <> nil then
  begin
    //FRPCBroker := RPCBroker;
    FScannedMeds := TList.Create;
    //FMedOrders := TList.Create;
    //FIVBags := TList.Create;
  end;

  //Clear;
end;

destructor TBCMA_OMMedOrder.Destroy;
begin
  (*
   if FChanged then
    if DefMessageDlg('The Patient data has been changed!'+#13#13+'Do you wish save your changes?',
           mtConfirmation, [mbYes, mbNo], 0) = idYes then
     SaveData;
  *)
//  Clear;
  //FMedOrders.Free;
  //FIVBags.Free;
  ClearScannedMeds;
  FScannedMeds.free;
  FRPCBroker := nil;

  inherited Destroy;
end;

procedure TBCMA_OMMedOrder.ClearScannedMeds;
var
  i: integer;
begin
  if FScannedMeds <> nil then
    with FScannedMeds do
    begin
      for i := count - 1 downto 0 do
        TBCMA_OMScannedMeds(items[i]).free;
      clear;
    end;
  //CQ 21970 - Erroneus data getting sent to IPM when an order is cancelled and new one created
  ClearOrder;
end;

procedure TBCMA_OMMedOrder.ClearOrder;
begin
    if MOBCallingAPP <> 'CPRS' then FProviderIEN := '';
    FInjectionSite := '';
    FAdminDateTime := '';
    FOrderType := '';
    FIVType := '';
    FIntSyringe := '';
    FSchedule := '';
    FOrderID := '';
end;

procedure TBCMA_OMScannedMeds.Clear;
begin

  FOrderableItemIEN := '';
  FOrderableItemName := '';
  FScannedDrugIEN := '';
  FScannedDrugName := '';
  FScannedDrugType := '';
  FVolume := '';

end;

procedure TBCMA_Patient.ClearOMMedOrders;
var
  i: integer;
begin
  if FOMMedorders <> nil then
    with FOMMedorders do
    begin
      for i := count - 1 downto 0 do
      begin
        TBCMA_OMMedOrder(items[i]).ClearScannedMeds;
        TBCMA_OMMedorder(items[i]).free;
      end;
      clear;
    end;
  FOMMedOrdersOrderID.Clear;

end;

procedure TBCMA_Patient.CancelOMMedOrders();
begin

end;

procedure TBCMA_Patient.SendOMMedOrders(OrderIDString: WideString);
var
  x: integer;
  zOrderID: string;
begin
  for x := 0 to FOMMedOrders.Count - 2 do
    with TBCMA_OMMedOrder(FOMMedOrders[x]) do
    begin
      zOrderID := Piece(OrderIDString, '^', x + 1);
      zOrderID := Piece(zOrderID, ';', 1);
      if zOrderID <> '-1' then
      begin
        SendOrder(zOrderID);
      end;
    end
end;

procedure TBCMA_OMMedOrder.SendOrder(OrderIDIn: string);
var
  index,
    x,
    ddCount,
    addCOunt,
    solCount: integer;
  MultList: TStringList;
  CmdString,
    DDString, ADDString, SOLString: string;
begin
  MultList := TStringList.Create;
  ddCount := 0;
  addCount := 0;
  solCount := 0;
  //with BCMA_Patient do
    if OMMedOrdersOrderID.Find(OrderIDIn, Index) then
    begin
      with TBCMA_OMMedOrder(OMMedOrders[index]) do
      begin
        CmdString := Patient.DFN + '^' + piece(FOrderID, ';', 1) +
          '^' + UpperCase(FSchedule);
        with MultList do
        begin
          add(FIVType);
          add(FIntSyringe);
          add(FAdminDateTime);

          for x := 0 to FScannedMeds.Count - 1 do
            with TBCMA_OMScannedMeds(FScannedMeds[x]) do
            begin
              if FScannedDrugType = 'DD' then
              begin
                ddCount := ddCount + 1;
                if DDString = '' then
                  DDString := FScannedDrugIEN + '^' + IntToStr(FUnitsPerDose)
                else
                  DDString := DDString + '^' + FScannedDrugIEN + '^' + IntToStr(FUnitsPerDose);
              end;

              if FScannedDrugType = 'ADD' then
              begin
                addCount := addCount + 1;
                if ADDString = '' then
                  ADDString := FAdditiveIEN
                else
                  ADDString := ADDString + '^' + FAdditiveIEN;
              end;
              if FScannedDrugType = 'SOL' then
              begin
                solCount := solCount + 1;
                if SOLString = '' then
                  SOLString := FSolutionIEN
                else
                  SOLString := SOLString + '^' + FSolutionIEN;
              end;
            end;

          add(IntToStr(ddCount));
          add(DDString);
          add(IntToStr(addCount));
          add(ADDString);
          add(IntToStr(solCount));
          add(SOLString);
          add(FInjectionSite);
          add(MOBInstructor);
          add('');
        end;
      end;
    end;
  if (BCMA_Broker <> nil) then
    with BCMA_Broker do
      if CallServer('PSB CPRS ORDER', [CmdString], MultList) then
        if Results[0] = '-1' then

end;

procedure TBCMA_OMMedOrder.GetSolAddStr(var SolutionList, AdditiveList: WideString);
var
  Solutions,
    Additives: WideString;
  x: integer;
begin
  Solutions := '';
  Additives := '';
  AdditiveList := '';
  SolutionList := '';
  for x := 0 to FScannedMeds.Count - 1 do
  begin
    if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'ADD' then
      if AdditiveList = '' then
        AdditiveList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
      else
        AdditiveList := AdditiveList + '^' + TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN
          //Additives.Add(TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN)
    else if TBCMA_OMScannedMeds(FScannedMeds[x]).FScannedDrugType = 'SOL' then
      if SolutionList = '' then
        SolutionList := TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
      else
        SolutionList := SolutionList + '^' + TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN +
          ';' + piece(TBCMA_OMScannedMeds(FScannedMeds[x]).FVolume, ' ', 1)
          //Solutions.Add(TBCMA_OMScannedMeds(FScannedMeds[x]).FOrderableItemIEN);
  end;
end;

constructor TBCMA_PRNEffectList.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FDispensedDrugs := TStringList.Create;
  FAdditives := TStringList.Create;
  FSolutions := TStringList.Create;
  Clear;
end;

destructor TBCMA_PRNEffectList.Destroy;
begin
  FRPCBroker := nil;
  Clear;
  FDispensedDrugs.Free;
  FAdditives.Free;
  FSolutions.Free;

  inherited Destroy;
end;

procedure TBCMA_PRNEffectList.Clear;
begin
  FMedLogIEN := '';
  FPatientLocation := '';
  FAdminDateTime := '';
  FAdministeredBy := '';
  FAdministeredMed := '';
  FPRNReason := '';
  FUnitsGiven := '';
  FSpecialInstructions := '';
  FOrderableItemIEN := '';
  FOrderNumber := '';
  FRequirePainScore := 0;

  FDispensedDrugs.Clear;
  FAdditives.Clear;
  FSolutions.Clear;
end;

destructor TBCMA_EditMedLog.Destroy;
begin
  clear;
  FRPCBroker := nil;
  FDispensedDrugs.Free;
  FSolutions.Free;
  FAdditives.Free;
  inherited Destroy;
end;

constructor TBCMA_EditMedLog.Create(RPCBroker: TBCMA_Broker);
begin
  inherited Create;
  if RPCBroker <> nil then
    FRPCBroker := RPCBroker;
  FDispensedDrugs := TStringList.Create;
  FAdditives := TStringList.Create;
  FSolutions := TStringList.Create;

end;

procedure TBCMA_EditMedLog.Clear;
begin
  FMLIEN := '';
  FPatientIEN := '';
  FPatientName := '';
  FSSN := '';
  FOrderableItem := '';
  FOrderableItemIEN := '';
  FBagID := '';
  FScanStatus := '';
  FOriginalScanStatus := '';
  FAdminDateTime := '';
  FMAdminDateTime := '';
  FInjectionSite := '';
  FPRNReason := '';
  FPRNEffectiveness := '';
  FScheduleType := '';
  FOrderStatus := '';
  FOrderNumber := '';
  FPatchBag := False;
  FDispensedDrugs.Clear;
  FSolutions.Clear;
  FAdditives.Clear;
  FComment := '';
  FTab := '';
end;

function TBCMA_EditMedLog.getScheduleTypeID: TScheduleTypes;
var
  id: TScheduleTypes;
begin
  result := stNone;
  if FRPCBroker <> nil then
    for id := low(ScheduleTypeCodes) to high(ScheduleTypeCodes) do
      if String(ScheduleTypeCodes[id]) = FScheduleType then
      begin
        result := id;
        break;
      end;
end;

function TBCMA_EditMedLog.getAdminStatusID: TScanStatus;
var
  id: TScanStatus;
begin
  result := ssUnknown;
  for id := low(ScanStatusCodes) to high(ScanStatusCodes) do
    if ScanStatusCodes[id] = ScanStatus then
    begin
      result := id;
      break;
    end;
end;

function TBCMA_EditMedLog.getIsPatch: Boolean;
var
  x: integer;
begin
  Result := False;
  if FDispensedDrugs.Count = 0 then exit;
  for x := 0 to FDispensedDrugs.Count - 1 do
    if piece(FDispensedDrugs[x], '^', 6) = 'PATCH' then
    begin
      Result := True;
      exit;
    end;
end;

procedure TBCMA_Patient.setshp(StringIn: string);
begin
  with BCMA_Patient do
  begin
    fActiveUDOrders := (piece(StringIn, '^', 1) = '1');
    fActivePBOrders := (piece(StringIn, '^', 2) = '1');
    fActiveIVOrders := (piece(StringIn, '^', 3) = '1');
  end;
end;

procedure TBCMA_TimerHandler.TimerEvent(Sender: TObject);
begin
  KeyedBarCode := True;
  KeyBoardTimer.Enabled := False;
end;
end.

