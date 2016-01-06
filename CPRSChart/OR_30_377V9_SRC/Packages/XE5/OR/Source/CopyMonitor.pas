{ ******************************************************************************
  {
  {                                 Copy/Paste
  {
  { This code will activly monitor and track both copy and paste from within and
  { between applications.
  {
  { Components:
  { TCopyApplicationMonitor
  {     This control is application wide and will contain the overall tracked
  {     clipboard.
  {
  { TCopyEditMonitor
  {     This control hooks into the desired trichedit and monitors the WMCopy and
  {     WMPaste messages. It is also responsible for loading the pasted text into
  {     the object.
  {
  { TCopyPasteDetails
  {     this is the visual element that will display the detials collected by
  {     TCopyEditMonitor.
  {
  { Conditional Defines:
  { CPLOG
  {     If the CPLOG conditional define is set then when a log file of the
  {     Copy/Paste process is created and saved in the user's
  {     AppData\Local\[Application name] folder. A document is created per
  {     process.
  {
  {
  {
  {
  {Modifications }

{ DONE -oChris Bell -cDisplay :(04/01/14) - Add date/time of original document
  ( if applicable) to the pasted data display. Update labels on display since
  they are misleading. }
{ DONE -oChris Bell -cDisplay :(04/01/14) Reorganize the pasted data details. }

{ TODO -oChris Bell -cEditMonitor : Create onshow and onhide events. Create events with inherited calls. }
{ ****************************************************************************** }
{$WARN XML_CREF_NO_RESOLVE OFF}  // Cref is formatted correctly
{$WARN XML_NO_MATCHING_PARM OFF} // This is related to the cref above for HighLightInfoPanel

unit CopyMonitor;

interface

uses
  SysUtils, Classes, RichEdit, ClipBrd, Windows, Messages, Controls, StdCtrls,
  Math, ComCtrls, CommCtrl, Graphics, Forms, Vcl.ExtCtrls, Vcl.Buttons,
  VA508AccessibilityRouter, SHFolder;

type
  /// <summary>Holds information about the copied/pasted text</summary>
  /// <param name="CopiedFromIEN">IEN where text was copied from<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="CopiedFromPackage">Package this text came from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></param>
  /// <param name="CopiedText">Text that was copied<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="OriginalText">Holds the text before any modifications<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="PercentMatch">Percent that pasted text matches this entry<para><b>Type: </b><c>Double</c></para></param>
  /// <param name="PercentData">The IEN and Package used for the Source. Delimited by a ;<para><b>Type: </b><c>String</c></para></param>
  /// <param name="ApplicationPackage">Application package that text came from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from CPRS this would be <example>OR</example></para></param>
  /// <param name="ApplicationName">Application text was copied from<para><b>Type: </b><c>String</c></para>
  /// <para><b>Example:</b> if copied from CPRS this would be <example>CPRS</example></para></param>
  /// <param name="DateTimeOfCopy"> Date and time of the copy<para><b>Type: </b><c>String</c></para></param>
  /// <param name="DateTimeOfPaste"> Date and time of the paste<para><b>Type: </b><c>String</c></para></param>
  /// <param name="PasteToIEN">IEN this data was pasted to<para><b>Type: </b><c>Integer</c></para></param>
  /// <param name="SaveForDocument">Flag used to "mark" for save into note<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="SaveToTheBuffer">Flag used to "mark" for save into buffer<para><b>Type: </b><c>Boolean</c></para></param>
  TCprsClipboard = record
    CopiedFromIEN: Integer;
    CopiedFromPackage: string;
    CopiedText: TStringList;
    OriginalText: TStringList;
    PercentMatch: Double;
    PercentData: String;
    ApplicationPackage: string;
    ApplicationName: string;
    DateTimeOfCopy: string;
    DateTimeOfPaste: String;
    PasteToIEN: Integer;
    SaveForDocument: Boolean;
    SaveToTheBuffer: Boolean;
  end;

  /// <summary><para>External call to load the pasted text</para><para><b>Type: </b><c>Integer</c></para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="LoadList">Load items into this list<para><b>Type: </b><c>TStrings</c></para></param>
  /// <param name="ProcessLoad">Flag determines if loading should continue<para><b>Type: </b><c>Boolean</c></para>
  /// <remarks><b>Default:</b><c> True</c></remarks></param>
  TLoadEvent = procedure(Sender: TObject; LoadList: TStrings;
    ProcessLoad: Boolean = true) of object;
  /// <summary><para>External call to save the pasted text</para><para><b>Type: </b><c>Integer</c></para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="SaveList">List containing items to save<para><b>Type: </b><c>TStrings</c></para></param>
  TSaveEvent = procedure(Sender: TObject; SaveList: TStringList) of object;
  /// <summary><para>External call to load the properties</para><para><b>Type: </b><c>Integer</c></para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  TLoadProperties = procedure(Sender: TObject) of object;

  /// <summary>This is the "overall" component. Each instance of <see cref="CopyMonitor|TCopyEditMonitor" /> will send into this.</summary>
  TCopyApplicationMonitor = class(TComponent)
  private
    /// <summary><para>Holds all records of copied/pasted text</para>
    /// <para><b>Type: </b><c>Array of <see cref="CopyMonitor|TCprsClipboard" /></c></para></summary>
    FCPRSClipBoard: array of TCprsClipboard;
    /// <summary><para>Percent used to match pasted text</para><para><b>Type:</b> <c>Double</c></para></summary>
    FPercentToVerify: Double;
    /// <summary><para>Number of words used to trigger copy/paste functionality</para><para><b>Type: </b><c>Double</c></para></summary>
    FNumberOfWords: Double;
    /// <summary><para>Flag that indicates if the buffer has been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedBuffer: Boolean;
    /// <summary><para>The monitoring application name</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringApplication: string;
    /// <summary><para>The monitoring application's package</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringPackage: string;
    /// <summary><para>External load buffer event</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadEvent" /></c></para></summary>
    FLoadBuffer: TLoadEvent;
    /// <summary><para>External save buffer event</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    FSaveBuffer: TSaveEvent;
    /// <summary><para>The current users DUZ</para><para><b>Type: </b><c>Int64</c></para></summary>
    FUserDuz: Int64;
    /// <summary><para>Color used to highlight the matched text</para><para><b>Type: </b><c>TColor</c></para></summary>
    FHighlightColor: TColor;
    /// <summary><para>Style to use for the matched text font</para><para><b>Type: </b><c>TFontStyles</c></para></summary>
    FMatchStyle: TFontStyles;
    /// <summary><para>Flag to display highlight when match found</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FMatchHighlight: Boolean;
    /// <summary><para>External load properties event</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadProperties" /></c></para></summary>
    FLoadProperties: TLoadProperties;
    /// <summary><para>Flag indicates if properties have been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedProperties: Boolean;
    /// <summary><para>Clipboard custom format for copy/paste</para><para><b>Type: </b><c>Word</c></para></summary>
    CF_CopyPaste: Word;
    /// <summary><para>Determines if we should log or not</para><para><b>Type: </b><c>Boolean</c></para></summary>
    fLogToFile: Boolean;
    /// <summary><para>The name of the Log File</para><para><b>Type: </b><c>String</c></para></summary>
    fOurLogFile: String;
    /// <summary>Adds the text being copied to the <see cref="CopyMonitor|TCprsClipboard" /> array and to the clipboard with details</summary>
    /// <param name="TextToCopy">Copied text<para><b>Type: </b><c>string</c></para></param>
    /// <param name="FromName">Copied text's package<para><b>Type: </b><c>string</c></para></param>
    /// <param name="ItemID">ID of document the text was copied from<para><b>Type: </b><c>Integer</c></para></param>
    procedure CopyToCopyPasteClipboard(TextToCopy, FromName: string;
      ItemID: Integer);
    /// <summary>Saved the copied text for this note</summary>
    /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TComponent</c></para></param>
    /// <param name="SaveList">List to save<para><b>Type: </b><c>TStringList</c></para></param>
    procedure SaveCopyPasteClipboard(Sender: TComponent; SaveList: TStringList);
    /// <summary>Clear out all SaveForDocument parameters</summary>
    procedure ClearCopyPasteClipboard();
    /// <summary>Perform the lookup of the pasted text and mark as such</summary>
    /// <param name="TextToPaste">Text being pasted</param>
    /// <param name="PasteDetails">Details from the clipboard</param>
    /// <param name="ItemIEN">Destination's IEN </param>
    procedure PasteToCopyPasteClipboard(TextToPaste, PasteDetails: string;
      ItemIEN: Integer);
    /// <summary>How many words appear in the text</summary>
    /// <param name="TextToCount">Occurences of</param>
    /// <returns>Total number of occurences</returns>
    function WordCount(TextToCount: string): Integer;
    /// <summary>Used to calcuate percent</summary>
    /// <param name="String1">Original string</param>
    /// <param name="String2">Compare String</param>
    /// <returns>Percentage the same</returns>
    function LevenshteinDistance(String1, String2: String): Double;
    /// <summary><para>Gets the log file</para></summary>
    /// <returns>The name of the log file<para><b>Type: </b><c>String</c></para> - </returns>
    function GetLogFileName(): String;
    /// <summary><para>Writes to the log file</para></summary>
    /// <param name="Action">This will be wrapped in []<para><b>Type: </b><c>string</c></para>
    /// <para><b>Example:</b> if action is paste (<example>mm/dd/yyyy hh:mm [PASTE]</example>)</para></param>
    /// <param name="Massage">The text to add to the log<para><b>Type: </b><c>string</c></para></param>
    procedure LogText(Action, Massage: String);
  protected
    { Protected declarations }
  public
    /// <summary>Constructor</summary>
    /// <param name="AOwner">Object that is calling this</param>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
  published
    /// <summary>Save copy buffer to VistA</summary>
    procedure SaveTheBuffer();
    /// <summary>Load the copy buffer from VistA</summary>
    procedure LoadTheBuffer();
    /// <summary>External Load Properties</summary>
    procedure LoadTheProperties();
    /// <summary>Percent to we consider this copy/paste functionality</summary>
    property PercentToVerify: Double read FPercentToVerify
      write FPercentToVerify;
    /// <summary>How many words do we start to consider this copy/paste</summary>
    property NumberOfWordsToBegin: Double read FNumberOfWords
      write FNumberOfWords;
    /// <summary>The application that we are monitoring</summary>
    property MonitoringApplication: string read FMonitoringApplication
      write FMonitoringApplication;
    /// <summary>The package that this application relates to</summary>
    property MonitoringPackage: string read FMonitoringPackage
      write FMonitoringPackage;
    /// <summary>The current users DUZ</summary>
    property UserDuz: Int64 read FUserDuz write FUserDuz;
    /// <summary>Call to load the buffer </summary>
    property LoadBuffer: TLoadEvent read FLoadBuffer write FLoadBuffer;
    /// <summary>Call to save the buffer </summary>
    property SaveBuffer: TSaveEvent read FSaveBuffer write FSaveBuffer;
    /// <summary>Color used to highlight the matched text</summary>
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    /// <summary>Style to use for the matched text font</summary>
    property MatchStyle: TFontStyles read FMatchStyle write FMatchStyle;
    /// <summary>Flag to display highlight when match found</summary>
    property MatchHighlight: Boolean read FMatchHighlight write FMatchHighlight;
    /// <summary>External load for the properties</summary>
    property LoadProperties: TLoadProperties read FLoadProperties
      write FLoadProperties;
  end;

  /// <summary>Used when loading/displaying pasted text</summary>
  /// <param name="DateTimeOfPaste">Date time of paste<para><b>Type: </b><c>string</c></para></param>
  /// <param name="DateTimeOfOriginalDoc">Date time the original document was created<para><b>Type: </b><c>string</c></para></param>
  /// <param name="UserWhoPasted">User who pasted<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromLocation">Where text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromDocument">Document IEN where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromAuthor">Author of the document where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromPatient">Patient where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="CopiedFromApplication">Application where the text was copied from<para><b>Type: </b><c>string</c></para></param>
  /// <param name="PastedPercentage">Percent matched when text was pasted<para><b>Type: </b><c>string</c></para></param>
  /// <param name="PastedText">Text that was pasted<para><b>Type: </b><c>TStringList</c></para></param>
  /// <param name="New">Flag for a new entry<para><b>Type: </b><c>Boolean</c></para></param>
  /// <param name="InfoPanelIndex">ItemIndex for this entry<para><b>Type: </b><c>Integer</c></para></param>
  TPasteText = record
    DateTimeOfPaste: string;
    DateTimeOfOriginalDoc: String;
    UserWhoPasted: string;
    CopiedFromLocation: string;
    CopiedFromDocument: string;
    CopiedFromAuthor: string;
    CopiedFromPatient: string;
    CopiedFromApplication: String;
    PastedPercentage: string;
    PastedText: TStringList;
    New: Boolean;
  //  ItemIEN: Integer;
    InfoPanelIndex: Integer;
  end;

  /// <summary>External call to allow the copy/paste functionality</summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
  /// <remarks>Used to exclude Documents from copy/paste functionality</remarks>
  TAllowMonitorEvent = procedure(Sender: TObject; var AllowMonitor: Boolean)
    of object;
  /// <summary><para>External call for Onshow/OnHide</para></summary>
  /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TObject</c></para></param>
  TVisible = procedure(Sender: TObject) of object;

  TVisualMessage = procedure(Sender: TObject; const CPmsg: Cardinal;
    CPVars: Array of Variant) of object;

  /// <summary>Thread used to task off the lookup when pasting</summary>
  TCopyPasteThread = class(TThread)
  private
    /// <summary><para>Lookup item's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    fItemIEN: Integer;
    /// <summary><para>Lookup item's text</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteText: String;
    /// <summary><para>Lookup item's <see cref="CopyMonitor|TCopyEditMonitor" /></para><para><b>Type: </b><c>TComponent</c></para></summary>
    fEditMonitor: TComponent;
    /// <summary><para>Lookup item's copy/paste format details</para><para><b>Type: </b><c>String</c></para></summary>
    fPasteDetails: String;
  protected
    /// <summary><para>Call to execute the thread</para></summary>
    procedure Execute; override;
  public
    /// <summary><para>Constructor</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="PasteText">Pasted text<para><b>Type: </b><c>String</c></para></param>
    /// <param name="PasteDetails">Pasted details<para><b>Type: </b><c>String</c></para></param>
    /// <param name="ItemIEN">Documents IEN that text was pasted into<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="EditMonitor">Documents <see cref="CopyMonitor|TCopyEditMonitor" /> that text was pasted into<para><b>Type: </b><c>TComponent</c></para></param>
    constructor Create(PasteText, PasteDetails: String; ItemIEN: Integer;
      EditMonitor: TComponent);
    /// <summary><para>Destructor</para></summary>
    destructor Destroy; override;
    /// <summary><para>Item IEN that this thread belongs to</para><para><b>Type: </b><c>Integer</c></para></summary>
    property TheadOwner: Integer read fItemIEN;
  end;

  /// <summary><para>Extend the TButton class</para></summary>
  TCollapseBtn = class(TButton)
  public
    procedure Click; override;
  end;

  /// <summary><para>Extend the TListBox class</para></summary>
  TSelectorBox = class(TListBox)
  public
    procedure Click; override;
  end;

  /// <summary><para>Non visual control that hooks into a control and monitors copy/paste. Sends data back to<see cref="CopyMonitor|TCopyApplicationMonitor" /> </para></summary>
  TCopyEditMonitor = class(TComponent)
  private
    /// <summary><para>"Overall" component that this should report to</para>
    /// <para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    FCopyMonitor: TCopyApplicationMonitor;
    /// <summary><para>Object to monitor</para><para><b>Type: </b><c>TCustomEdit</c></para></summary>
    FMonitorObject: TCustomEdit;
    /// <summary><para>Original WndProc</para><para><b>Type: </b><c>TWndMethod</c></para></summary>
    FOldWndProc: TWndMethod;
    /// <summary><para>External event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FCopyToMonitor: TAllowMonitorEvent;
    /// <summary><para>External event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    FPasteToMonitor: TAllowMonitorEvent;
    /// <summary><para>External event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    FSaveTheMonitor: TSaveEvent;
    /// <summary><para>External event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TLoadEvent" /></c></para></summary>
    FLoadPastedText: TLoadEvent;
    /// <summary><para>Call used to determine if visual panel should show. Should only be called from <c><see cref="CopyMonitor|TCopyPasteDetails" /></c></para><para><b>Type: </b><c><see cref="CopyMonitor|TVisualMessage" /></c></para></summary>
    FVisualMessage: TVisualMessage;
    /// <summary><para>The current document IEN</para><para><b>Type: </b><c>Int64</c></para></summary>
    fItemIEN: Int64;
    /// <summary><para>Package related to this monitor</para><para><b>Type: </b><c>string</c></para>
    /// <para><b>Example:</b> if copied from a note (TIU package) this would be <example>8925</example></para></summary>
    FRelatedPackage: string;
    /// <summary><para>Holds list of currently running threads</para><para><b>Type: </b><c>Array of <see cref="CopyMonitor|tCopyPasteThread" /></c></para></summary>
    FCopyPasteThread: Array of TCopyPasteThread;
    /// <summary><para>Assign object to monitor</para></summary>
    /// <param name="ACopyObject">Object to montior<para><b>Type: </b><c>TCustomEdit</c></para>
    /// <para><b>Example:</b><example>TRichEdit</example></para></param>
    procedure SetObjectToMonitor(ACopyObject: TCustomEdit);
    /// <summary><para>hook into the wm copy and pastes</para></summary>
    /// <param name="Msg">The message to process<para><b>Type: </b><c>TMessage</c></para></param>
    procedure WndProc(var Msg: TMessage);
    /// <summary><para>Save off the original winproc so it can be called from the overwrite</para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure HookEditWnd;
    /// <summary><para>Event triggered when data is copied from the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="Msg">The message to process<para><b>Type: </b><c>TMessage</c></para></param>
    procedure CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
      Msg: TMessage);
    /// <summary><para>Event triggered when data is pasted into the monitoring object</para></summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="AllowMonitor">Flag indicates if this is excluded or not<para><b>Type: </b><c>Boolean</c></para></param>
    procedure PasteToMonitor(Sender: TObject; AllowMonitor: Boolean);
    /// <summary>Sets the ItemIEN</summary>
    /// <param name="NewItemIEN">New IEN to set to<para><b>Type: </b><c>Int64</c></para></param>
    procedure SetItemIEN(NewItemIEN: Int64);
  protected
    { Protected declarations }
  public
    /// <summary><para>Holds all records of pasted text for the specific document</para>
    /// <para><b>Type: </b><c>Array of <see cref="CopyMonitor|TPasteText" /></c></para></summary>
    PasteText: array of TPasteText;
    /// <summary><para>The current document's IEN</para><para><b>Type: </b><c>Integer</c></para></summary>
    property ItemIEN: Int64 read fItemIEN write SetItemIEN;
    /// <summary><para>Calls <see cref="CopyMonitor|TCopyApplicationMonitor.ClearCopyPasteClipboard" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    procedure ClearTheMonitor();
    /// <summary><para>Save the Monitor for the current document</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ItemID">Document's IEN<para><b>Type: </b><c>Integer</c></para></param>
    procedure SaveTheMonitor(ItemID: Integer);
    /// <summary>Finds pasted text for a given document</summary>
    procedure LoadPasteText();
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary>Clears the <see cref="CopyMonitor|TCopyEditMonitor.PasteText" /></summary>
    procedure ClearPasteArray();
  published
    /// <summary><para>The "Parent" component that monitors the application</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyApplicationMonitor" /></c></para></summary>
    property CopyMonitor: TCopyApplicationMonitor read FCopyMonitor
      write FCopyMonitor;
    /// <summary><para>Object to monitor</para><para><b>Type: </b><c>TCustomEdit</c></para></summary>
    property MonitorObject: TCustomEdit read FMonitorObject
      write SetObjectToMonitor;
    /// <summary><para>Event to fire when copying</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnCopyToMonitor: TAllowMonitorEvent read FCopyToMonitor
      write FCopyToMonitor;
    /// <summary><para>Event to fire when pasting</para><para><b>Type: </b><c><see cref="CopyMonitor|TAllowMonitorEvent" /></c></para></summary>
    property OnPasteToMonitor: TAllowMonitorEvent read FPasteToMonitor
      write FPasteToMonitor;
    /// <summary><para>Event to fire when saving</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnSaveTheMonitor: TSaveEvent read FSaveTheMonitor
      write FSaveTheMonitor;
    /// <summary><para>Event to fire when loading</para><para><b>Type: </b><c><see cref="CopyMonitor|TSaveEvent" /></c></para></summary>
    property OnLoadPastedText: TLoadEvent read FLoadPastedText
      write FLoadPastedText;
    /// <summary><para>Package this object's monitor is related to</para><para><b>Type: </b><c><see cref="CopyMonitor|TCopyEditMonitor.FRelatedPackage" /></c></para></summary>
    property RelatedPackage: string read FRelatedPackage write FRelatedPackage;
  end;

  /// <summary><para>Visual control that hooks into a control and monitors copy/paste. Sends data back to<see cref="CopyMonitor|TCopyApplicationMonitor" /> </para></summary>
  TCopyPasteDetails = class(TPanel)
  private
    /// <summary><para>Uses all the same logic from <see cref="CopyMonitor|TCopyEditMonitor" /></para></summary>
    fEditMonitor: TCopyEditMonitor;
    /// <summary><para>External event to fire when showing the infopanel</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    FShow: TVisible;
    /// <summary><para>External event to fire when hiding the infopanel</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    FHide: TVisible;
    /// <summary><para>Contains the details for the selected entry in <see cref="CopyMonitor|TCopyEditMonitor.FInfoSelector" /></para><para><b>Type: </b><c>TRichEdit</c></para></summary>
    FInfoMessage: TRichEdit;
    /// <summary><para>List of pasted entries for <see cref="CopyMonitor|TCopyEditMonitor.FMonitorObject" /></para><para><b>Type: </b><c>TSelectorBox</c></para></summary>
    FInfoSelector: TSelectorBox;
    /// <summary><para>Button used to collapse the <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /></para><para><b>Type: </b><c>TCollapseBtn</c></para></summary>
    FCollapseBtn: TCollapseBtn;
    /// <summary><para>Flag used to determine if the <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /> is collapsed</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FInfoboxCollapsed: Boolean;
    /// <summary><para>Last height of the  <see cref="CopyMonitor|TCopyEditMonitor.FInfoPanel" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    FLastInfoboxHeight: Integer;
    /// <summary><para>Cursor position in <see cref="CopyMonitor|TCopyEditMonitor.FMonitorObject" /> where the text was pasted</para><para><b>Type: </b><c>Integer</c></para></summary>
    FPasteCurPos: Integer;
    /// <summary><para>Flag to detemine if OnResize should be suspended</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FSuspendResize: Boolean;
    /// <summary>Responsible for loading the results into the "Info Panel"</summary>
    procedure ReloadInfoPanel();
    /// <summary>Responsible for displaying the "Info Panel"</summary>
    /// <param name="Toggle">Determines if this should display or not<para><b>Type: </b><c>Boolean</c></para></param>
    procedure ShowInfoPanel(Toggle: Boolean);
    /// <summary>Removes the highlighting from the monitoring object</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure pnlMessageExit(Sender: TObject);
    /// <summary>Loads the details for the selected past entry</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure lbSelectorClick(Sender: TObject);
    /// <summary>Highlights the pasted data in the monitor object (TRichedit)</summary>
    /// <param name="Color">Color from  <see cref="CopyMonitor|TCopyApplicationMonitor.HighlightColor" /><para><b>Type: </b><c>TColor</c></para></param>
    /// <param name="Style">Style from  <see cref="CopyMonitor|TCopyApplicationMonitor.MatchStyle" /><para><b>Type: </b><c>TFontStyles</c></para></param>
    /// <param name="ShowHighlight">Flag from <see cref="CopyMonitor|TCopyApplicationMonitor.MatchHighlight" /><para><b>Type: </b><c>Boolean</c></para></param>
    /// <param name="PasteText">Pasted data from <see cref="CopyMonitor|TCopyEditMonitor.PasteText" /> <para><b>Type: </b><c>String</c></para></param name="PasteText">
    procedure HighLightInfoPanel(Color: TColor; Style: TFontStyles;
      ShowHighlight: Boolean; PasteText: String);
    /// <summary>Handles the collapse/expand of the "Info Panel"</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure CloseInfoPanel(Sender: TObject);
    /// <summary>Handles the manual resizing of the "Info Panel"</summary>
    /// <param name="Sender">Object that is making the call<para><b>Type: </b><c>TObject</c></para></param>
    procedure InfoPanelResize(Sender: TObject);
    /// <summary><para>Determines if the panel should show</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="sender">sender<para><b>Type: </b><c>TObject</c></para></param>
    /// <param name="CPmsg">CPmsg<para><b>Type: </b><c>Cardinal</c></para></param>
    /// <param name="CPVars">CPVars<para><b>Type: </b><c>Array of Variant</c></para></param>
    Procedure VisualMesageCenter(Sender: TObject; const CPmsg: Cardinal;
      CPVars: Array of Variant);
  public
    /// <summary>constructor</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary><para>Calls <see cref="CopyMonitor|TCopyEditMonitor.ShowInfoPanel" /></para><para><b>Type: </b><c>Integer</c></para></summary>
    property FInfoPanelVisible: Boolean write ShowInfoPanel;
    /// <summary><para>Override the DoExit procedure</para></summary>
    procedure DoExit; override;
    /// <summary><para>Override the Resize procedure</para></summary>
    procedure Resize; override;
  published
    /// <summary><para>Uses all the same logic from <see cref="CopyMonitor|TCopyEditMonitor" /></para></summary>
    property EditMonitor: TCopyEditMonitor read fEditMonitor;
    /// <summary><para>Contains the pasted details</para><para><b>Type: </b><c>TRichEdit</c></para></summary>
    property InfoMessage: TRichEdit read FInfoMessage;
    /// <summary><para>Button used to collapse or expand the panel</para><para><b>Type: </b><c>TCollapseBtn</c></para></summary>
    property CollapseBtn: TCollapseBtn read FCollapseBtn;
    /// <summary><para>Displays the selectable entries</para><para><b>Type: </b><c>TSelectorBox</c></para></summary>
    property InfoSelector: TSelectorBox read FInfoSelector;
    /// <summary><para>Event to fire when showing</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    property OnShow: TVisible read FShow write FShow;
    /// <summary><para>Event to fire when hiding</para><para><b>Type: </b><c><see cref="CopyMonitor|TVisible" /></c></para></summary>
    property OnHide: TVisible read FHide write FHide;
  end;

  /// <summary><para>Returns the Nth piece (PieceNum) of a string delimited by Delim</para></summary>
  /// <param name="S">String to search<para><b>Type: </b><c>string</c></para></param>
  /// <param name="Delim">Character used as the delemiter<para><b>Type: </b><c>char</c></para></param>
  /// <param name="PieceNum">Number of delemieted text for the return<para><b>Type: </b><c>Integer</c></para></param>
  /// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function Piece(const S: string; Delim: char; PieceNum: Integer): string;
/// <summary><para>Format fmDateTime</para></summary>
/// <param name="AFormat">The format to use<para><b>Type: </b><c>string</c></para></param>
/// <param name="ADateTime">The date/time<para><b>Type: </b><c>Double</c></para></param>
/// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
/// <summary><para>converts a Delphi date/time type to a Fileman date/time</para><para><b>Type: </b><c>Integer</c></para></summary>
/// <param name="ADateTime">The date/time<para><b>Type: </b><c>TDateTime</c></para></param>
/// <returns><para><b>Type: </b><c>Double</c></para> - </returns>
function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
/// <summary><para>Remove special characters</para><para><b>Type: </b><c>Integer</c></para></summary>
/// <param name="X">String to filter<para><b>Type: </b><c>string</c></para></param>
/// <param name="ATabWidth">Length of the tab<para><b>Type: </b><c>Integer</c></para></param>
/// <returns><para><b>Type: </b><c>string</c></para> - </returns>
function FilteredString(const X: string; ATabWidth: Integer = 8): string;

const
  { names of months used by FormatFMDateTime }
  MONTH_NAMES_SHORT: array [1 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  MONTH_NAMES_LONG: array [1 .. 12] of string = ('January', 'February', 'March',
    'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December');

  Show_Panel = $1000;
  ShowAndSelect_Panel = $1001;
  Hide_Panel = $1002;
procedure Register;

implementation

uses Types;

procedure Register;
begin
  RegisterComponents('CPRS', [TCopyApplicationMonitor, TCopyEditMonitor,
    TCopyPasteDetails]);
end;

{$REGION 'CopyApplicationMonitor'}

procedure TCopyApplicationMonitor.ClearCopyPasteClipboard;
var
  i: Integer;
begin
  for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
  begin
    FCPRSClipBoard[i].SaveForDocument := false;
    FCPRSClipBoard[i].DateTimeOfPaste := '';
    FCPRSClipBoard[i].PasteToIEN := -1;
  end;
  if fLogToFile then
    LogText('SAVE', 'Clearing all pasted data that was marked for save');

end;

procedure TCopyApplicationMonitor.PasteToCopyPasteClipboard(TextToPaste,
  PasteDetails: string; ItemIEN: Integer);
var
  TextFound: Boolean;
  i, PosToUSe: Integer;
  PertoCheck, LastPertToCheck: Double;
  CompareText: TStringList;
begin
  if not FLoadedProperties then
    LoadTheProperties;
  if not FLoadedBuffer then
    LoadTheBuffer;
  TextFound := false;
  CompareText := TStringList.Create;
  try
   CompareText.Text := TextToPaste; //Apples to Apples

  // Direct macthes
  for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
  begin
    If AnsiSameText(Trim(FCPRSClipBoard[i].CopiedText.Text), Trim(CompareText.Text)) then
    begin
      if (FCPRSClipBoard[i].CopiedFromIEN <> ItemIEN) then
      begin
        FCPRSClipBoard[i].SaveForDocument :=
          (FCPRSClipBoard[i].CopiedFromIEN <> ItemIEN);
        FCPRSClipBoard[i].DateTimeOfPaste :=
          FloatToStr(DateTimeToFMDateTime(Now));
        FCPRSClipBoard[i].CopiedFromPackage := FCPRSClipBoard[i]
          .CopiedFromPackage; // ????????
        FCPRSClipBoard[i].PercentMatch := 100.00;
        FCPRSClipBoard[i].PasteToIEN := ItemIEN;

        if fLogToFile then
        begin
          // Log info
          LogText('PASTE', 'Direct Match Found');
          LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
          LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
          LogText('PASTE', 'Matched to Text IEN(' +
            IntToStr(FCPRSClipBoard[i].CopiedFromIEN) + '):');
          LogText('TEXT', 'Matched to Text: ' + #13#10 +
            Trim(FCPRSClipBoard[i].CopiedText.Text));
        end;
      end;
      TextFound := true;
      Break;
    end;
  end;

  // Partial match
  if not TextFound then
  begin
    LastPertToCheck := 0;
    PosToUSe := -1;
  //  PertoCheck := 0;
    for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
    begin

      PertoCheck := LevenshteinDistance(Trim(FCPRSClipBoard[i].CopiedText.Text),
        CompareText.Text);
      // PertoCheck := TPasteIsInternalPercent.PercentTheSame(Trim(FCPRSClipBoard[I].CopiedText.Text), TextToPaste);
      if PertoCheck > LastPertToCheck then
      begin
        if PertoCheck > FPercentToVerify then
        begin
          PosToUSe := i;
          LastPertToCheck := PertoCheck;
        end;
      end;

    end;
    if PosToUSe <> -1 then
    begin
      If (FCPRSClipBoard[PosToUSe].CopiedFromIEN <> ItemIEN) then
      begin
        if fLogToFile then
        begin
          LogText('PASTE', 'Partial Match: %' +
            FloatToStr(round(LastPertToCheck)));
          LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
          LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
          LogText('PASTE', 'Matched to Text IEN(' +
            IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN) + ')');
          LogText('TEXT', 'Matched to Text: ' + #13#10 +
            Trim(FCPRSClipBoard[PosToUSe].CopiedText.Text));
          LogText('PASTE', 'Added to internal clipboard IEN(-1)');
        end;

        { FCPRSClipBoard[PosToUSe].SaveForDocument := ItemIEN <> FCPRSClipBoard
          [PosToUSe].CopiedFromIEN;
          FCPRSClipBoard[PosToUSe].DateTimeOfPaste :=
          FloatToStr(DateTimeToFMDateTime(Now));
          FCPRSClipBoard[PosToUSe].PercentMatch := round(LastPertToCheck);
          FCPRSClipBoard[PosToUSe].OriginalText := TStringList.Create;
          FCPRSClipBoard[PosToUSe].OriginalText.Text := FCPRSClipBoard[PosToUSe]
          .CopiedText.Text;
          FCPRSClipBoard[PosToUSe].CopiedText.Text := TextToPaste;
        }

        // add new
        SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN := -1;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
          'Outside of current ' + MonitoringApplication + ' tracking';
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
          MonitoringPackage;
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
          MonitoringApplication;
        FCPRSClipBoard[High(FCPRSClipBoard)].PercentMatch :=
          round(LastPertToCheck);

       FCPRSClipBoard[High(FCPRSClipBoard)].PercentData :=
       IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN) +';'+
       FCPRSClipBoard[PosToUSe].CopiedFromPackage;
       FCPRSClipBoard[High(FCPRSClipBoard)].PasteToIEN := ItemIEN;

        FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
          FloatToStr(DateTimeToFMDateTime(Now));
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := true;
        FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfPaste :=
          FloatToStr(DateTimeToFMDateTime(Now));
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := true;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText.Text := CompareText.Text;
        FCPRSClipBoard[PosToUSe].OriginalText := TStringList.Create;
        FCPRSClipBoard[PosToUSe].OriginalText.Text := FCPRSClipBoard[PosToUSe]
          .CopiedText.Text;

      end;
      TextFound := true;
    end;
  end;

  // add outside paste in here
  if (not TextFound) and (WordCount(CompareText.Text) >= FNumberOfWords) then
  begin
    // Look for the details first
    SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);

    if Length(PasteDetails) > 0 then
    begin
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN :=
        StrToIntDef(Piece(PasteDetails, '^', 1), -1);
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
        Piece(PasteDetails, '^', 2);
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
        Piece(PasteDetails, '^', 3);
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
        Piece(PasteDetails, '^', 4);
      FCPRSClipBoard[High(FCPRSClipBoard)].PercentMatch := 100.0;
      if fLogToFile then
      begin
        LogText('PASTE', 'Paste from cross session ' + PasteDetails);
        LogText('PASTE', 'Added to internal clipboard IEN(-1)');
      end;
    end
    else
    begin
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN := -1;
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
        'Outside of current ' + MonitoringApplication + ' tracking';
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
        MonitoringPackage;
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
        MonitoringApplication;
      FCPRSClipBoard[High(FCPRSClipBoard)].PercentMatch := 0.0;
      if fLogToFile then
      begin
        LogText('PASTE', 'Pasted from outside the tracking');
        LogText('PASTE]', 'Added to internal clipboard IEN(-1)');
      end;
    end;
    FCPRSClipBoard[High(FCPRSClipBoard)].PasteToIEN := ItemIEN;
    FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
      FloatToStr(DateTimeToFMDateTime(Now));
    FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := true;
    FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfPaste :=
      FloatToStr(DateTimeToFMDateTime(Now));
    FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := true;
    FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
    FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText.Text := CompareText.Text;
  end;
  finally
    CompareText.Free;
  end;
end;

procedure TCopyApplicationMonitor.SaveCopyPasteClipboard(Sender: TComponent;
  SaveList: TStringList);
var
  i, X, SaveCnt, IEN2Use: Integer;
  Package2Use: String;
begin

  SaveList.Text := '';
  if (Sender is TCopyEditMonitor) then
  begin

    with (Sender as TCopyEditMonitor) do
    begin

      SaveCnt := 0;
      for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        if FCPRSClipBoard[i].SaveForDocument = true then
        begin
          Inc(SaveCnt);
          if FCPRSClipBoard[i].PercentMatch <> 100 then
          begin
           IEN2Use := StrToIntDef(Piece(FCPRSClipBoard[i].PercentData, ';', 1), -1);
           Package2Use := Piece(FCPRSClipBoard[i].PercentData, ';', 2);
          end else  begin
           IEN2Use :=  FCPRSClipBoard[i].CopiedFromIEN;
           Package2Use := FCPRSClipBoard[i].CopiedFromPackage;
          end;


          SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
            FCPRSClipBoard[i].DateTimeOfPaste + '^' + IntToStr(ItemIEN) + ';' +
            RelatedPackage + '^' + IntToStr(IEN2Use) +
            ';' + Package2Use + '^' +
            FloatToStr(FCPRSClipBoard[i].PercentMatch) + '^' + FCPRSClipBoard[i]
            .ApplicationPackage + '^' + FCPRSClipBoard[i].ApplicationName);

          SaveList.Add(IntToStr(SaveCnt) + ',-1=' +
            IntToStr(FCPRSClipBoard[i].CopiedText.Count));
          for X := 0 to FCPRSClipBoard[i].CopiedText.Count - 1 do
            SaveList.Add(IntToStr(SaveCnt) + ',' + IntToStr(X + 1) + '=' +
              FilteredString(FCPRSClipBoard[i].CopiedText[X]));

          // Send in  the original text if needed
          If Assigned(FCPRSClipBoard[i].OriginalText) then
          begin
            SaveList.Add(IntToStr(SaveCnt) + ',0,-1=' +
              IntToStr(FCPRSClipBoard[i].OriginalText.Count));
            for X := 0 to FCPRSClipBoard[i].OriginalText.Count - 1 do
              SaveList.Add(IntToStr(SaveCnt) + ',0,' + IntToStr(X + 1) + '=' +
                FilteredString(FCPRSClipBoard[i].OriginalText[X]));
          end;

        end;
      end;
      SaveList.Add('TotalToSave=' + IntToStr(SaveCnt));
      if fLogToFile then
        LogText('SAVE', 'Saved ' + IntToStr(SaveCnt) + ' Items');
      ClearCopyPasteClipboard();
    end;
  end;
end;

procedure TCopyApplicationMonitor.CopyToCopyPasteClipboard(TextToCopy,
  FromName: string; ItemID: Integer);
var
  i: Integer;
  Found: Boolean;
  CopyDetials: String;
  OurHandle: HGLOBAL;
  OurPointer: Pointer;
begin
  Found := false;
  if not FLoadedProperties then
    LoadTheProperties;
  if not FLoadedBuffer then
    LoadTheBuffer;
  if fLogToFile then
    LogText('COPY', 'Copying data from IEN(' + IntToStr(ItemID) + ')');
  if WordCount(TextToCopy) >= FNumberOfWords then
  begin
    // check if this already exist
    for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
    begin
      if FCPRSClipBoard[i].CopiedFromPackage = UpperCase(FromName) then
      begin
        if FCPRSClipBoard[i].CopiedFromIEN = ItemID then
        begin
          if AnsiSameText(Trim(FCPRSClipBoard[i].CopiedText.Text), Trim(TextToCopy)) then
          begin
            Found := true;
            if fLogToFile then
              LogText('COPY', 'Copied data already being monitored');
            Break;
          end;
        end;
      end;
    end;

    // Copied text doesn't exist so add it in
    if (not Found) and (WordCount(TextToCopy) >= FNumberOfWords) then
    begin
      if fLogToFile then
        LogText('COPY', 'Adding copied data to session tracking');
      SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN := ItemID;
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
        UpperCase(FromName);
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
        MonitoringPackage;
      FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
        MonitoringApplication;
      FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
        FloatToStr(DateTimeToFMDateTime(Now));
      FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
      FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := true;
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
      FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText.Text := TextToCopy;
    end;
  end;
  Clipboard.Open;
  try
    Clipboard.Clear;
    if fLogToFile then
      LogText('COPY', 'Setting up the multiple session clipboard');
    // Details
    CopyDetials := IntToStr(ItemID) + '^' + UpperCase(FromName) + '^' +
      MonitoringPackage + '^' + MonitoringApplication;
    OurHandle := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE,
      (Length(CopyDetials)) + 1);
    OurPointer := GlobalLock(OurHandle);
    Move(PAnsiChar(AnsiString(CopyDetials))^, OurPointer^,
      Length(CopyDetials) + 1);
    Clipboard.SetAsHandle(CF_CopyPaste, OurHandle);
    if fLogToFile then
    begin
      LogText('COPY', 'Details ' + CopyDetials);
      LogText('COPY', 'Details Handle:' + IntToStr(OurHandle));
    end;
    // text
    OurHandle := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE,
      (Length(TextToCopy)) + 1);
    OurPointer := GlobalLock(OurHandle);
    Move(PAnsiChar(AnsiString(TextToCopy))^, OurPointer^,
      Length(TextToCopy) + 1);
    Clipboard.SetAsHandle(CF_TEXT, OurHandle);
    GlobalUnlock(OurHandle);
    if fLogToFile then
      LogText('COPY', 'Text Handle:' + IntToStr(OurHandle));
  finally
    Clipboard.Close;
  end;
  // end;
end;

constructor TCopyApplicationMonitor.Create(AOwner: TComponent);
Var
  i: Integer;
begin
  inherited;
  FLoadedBuffer := false;
  FLoadedProperties := false;
  FHighlightColor := clYellow;
  FMatchStyle := [];
  FMatchHighlight := true;
  CF_CopyPaste := RegisterClipboardFormat('CF_CopyPaste');
  fLogToFile := false;
  for i := 1 to ParamCount do
  begin
    if UpperCase(ParamStr(i)) = 'CPLOG' then
    begin
      fLogToFile := true;
      Break;
    end;
  end;

  if fLogToFile then
  begin
    LogText('START', StringOfChar('*', 20) +
      FormatDateTime('mm/dd/yyyy hh:mm:ss', Now) + StringOfChar('*', 20));
    LogText('INIT', 'Monitor object created');
  end;

end;

destructor TCopyApplicationMonitor.Destroy;
var
  i: Integer;
begin
  inherited;
  // Clear copy arrays
  for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
  begin
    FCPRSClipBoard[i].CopiedText.Free;
    If Assigned(FCPRSClipBoard[i].OriginalText) then
      FCPRSClipBoard[i].OriginalText.Free;
  end;
  SetLength(FCPRSClipBoard, 0);
  if fLogToFile then
  begin
    LogText('INIT', 'Monitor object destroyed');
    LogText('STOP', StringOfChar('*', 20) +
      FormatDateTime('mm/dd/yyyy hh:mm:ss', Now) + StringOfChar('*', 20));
  end;
end;

procedure TCopyApplicationMonitor.LoadTheBuffer();
var
  BufferList: TStringList;
  i, X: Integer;
  NumLines, BuffParent: Integer;
  ProcessLoad: Boolean;
begin
  BufferList := TStringList.Create();
  try
    ProcessLoad := true;
    BuffParent := 0;

    if Assigned(FLoadBuffer) then
      FLoadBuffer(self, BufferList, ProcessLoad);

    if ProcessLoad then
    begin
      if fLogToFile then
        LogText('BUFF', 'Loading the buffer.' + BufferList.Values['(0,0)'] +
          ' Items.');

      if BufferList.Count > 0 then
        BuffParent := StrToIntDef(BufferList.Values['(0,0)'], -1);
      for i := 1 to BuffParent do
      begin // first line is the total number
        if fLogToFile then
          LogText('BUFF', 'Buffer item (' + IntToStr(i) + '): ' +
            BufferList.Values['(' + IntToStr(i) + ',0)']);

        SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
        FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := false;
        FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
          Piece(BufferList.Values['(' + IntToStr(i) + ',0)'], '^', 1);
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
          Piece(BufferList.Values['(' + IntToStr(i) + ',0)'], '^', 3);
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN :=
          StrToIntDef(Piece(Piece(BufferList.Values['(' + IntToStr(i) + ',0)'],
          '^', 4), ';', 1), -1);
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
          Piece(Piece(BufferList.Values['(' + IntToStr(i) + ',0)'], '^',
          4), ';', 2);
        FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
          Piece(BufferList.Values['(' + IntToStr(i) + ',0)'], '^', 6);
        FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
        NumLines := StrToIntDef
          (Piece(BufferList.Values['(' + IntToStr(i) + ',0)'], '^', 5), -1);
        for X := 1 to NumLines do
          FCPRSClipBoard[High(FCPRSClipBoard)
            ].CopiedText.Add(BufferList.Values['(' + IntToStr(i) + ',' +
            IntToStr(X) + ')']);

      end;
      FLoadedBuffer := true;
    end;

  finally
    BufferList.Free;
  end;
end;

procedure TCopyApplicationMonitor.SaveTheBuffer();
var
  SaveList: TStringList;
  i, X, SaveCnt: Integer;
begin
  SaveList := TStringList.Create;
  try
    SaveCnt := 0;
    if fLogToFile then
      LogText('BUFF', 'Preparing Buffer for Save');
    for i := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
    begin
      if FCPRSClipBoard[i].SaveToTheBuffer then
      begin
        Inc(SaveCnt);
        SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
          FCPRSClipBoard[i].DateTimeOfCopy + '^' +
          IntToStr(FCPRSClipBoard[i].CopiedFromIEN) + ';' + FCPRSClipBoard[i]
          .CopiedFromPackage + '^' + FCPRSClipBoard[i].ApplicationPackage + '^'
          + FCPRSClipBoard[i].ApplicationName);
        SaveList.Add(IntToStr(SaveCnt) + ',-1=' +
          IntToStr(FCPRSClipBoard[i].CopiedText.Count));
        for X := 0 to FCPRSClipBoard[i].CopiedText.Count - 1 do
          SaveList.Add(IntToStr(SaveCnt) + ',' + IntToStr(X + 1) + '=' +
            FilteredString(FCPRSClipBoard[i].CopiedText[X]));

      end;
    end;
    SaveList.Add('TotalBufferToSave=' + IntToStr(SaveCnt));
    if fLogToFile then
      LogText('BUFF', IntToStr(SaveCnt) + ' Items ready to save');
    if Assigned(FSaveBuffer) then
      FSaveBuffer(self, SaveList);
  finally
    SaveList.Free;
  end;
end;

procedure TCopyApplicationMonitor.LoadTheProperties();
begin
  if not FLoadedProperties and Assigned(FLoadProperties) then
  begin
    FLoadProperties(self);
    if fLogToFile then
    begin
      // Log the properties
      LogText('PROP', 'Loading properties');
      LogText('PROP', 'Number of words:' + FloatToStr(FNumberOfWords));
      LogText('PROP', 'Percent to verify:' + FloatToStr(PercentToVerify));
    end;
  end;
  FLoadedProperties := true;

end;

function TCopyApplicationMonitor.WordCount(TextToCount: string): Integer;
var
  CharCnt: Integer;

  function IsEnd(CharToCheck: char): Boolean;
  begin
    result := CharInSet(CharToCheck, [#0 .. #$1F, ' ', '.', ',', '?', ':', ';',
      '(', ')', '/', '\']);
  end;

begin
  result := 0;
  CharCnt := 1;
  while CharCnt <= Length(TextToCount) do
  begin
    while (CharCnt <= Length(TextToCount)) and (IsEnd(TextToCount[CharCnt])) do
      Inc(CharCnt);
    if CharCnt <= Length(TextToCount) then
    begin
      Inc(result);
      while (CharCnt <= Length(TextToCount)) and
        (not IsEnd(TextToCount[CharCnt])) do
        Inc(CharCnt);
    end;
  end;
end;

function TCopyApplicationMonitor.LevenshteinDistance(String1,
  String2: String): Double;
var
  Length1, Length2: Integer;
  Matrix: array of array of Integer;
  i, j: Integer;
  Cost: Integer;
  Val1, Val2, Val3: Integer;
begin
  String1 := UpperCase(String1);
  String2 := UpperCase(String2);
  Length1 := Length(String1);
  Length2 := Length(String2);
  SetLength(Matrix, Length1 + 1, Length2 + 1);

  for i := 0 to Length1 do
    Matrix[i, 0] := i;
  for j := 0 to Length2 do
    Matrix[0, j] := j;

  for i := 1 to Length1 do
  begin
    for j := 1 to Length2 do
    begin
      begin
        if (String1[i] = String2[j]) then
          Cost := 0
        else
          Cost := 1;

        Val1 := Matrix[i - 1, j] + 1;
        Val2 := Matrix[i, j - 1] + 1;
        Val3 := Matrix[i - 1, j - 1] + Cost;

        if (Val1 < Val2) then
          if (Val1 < Val3) then
            Matrix[i, j] := Val1
          else
            Matrix[i, j] := Val3
        else if (Val2 < Val3) then
          Matrix[i, j] := Val2
        else
          Matrix[i, j] := Val3;
      end;
    end;
  end;
  // Result := Matrix[Length1, Length2];
  result := (1 - (Matrix[Length1, Length2] / Max(Length1, Length2))) * 100;
end;

function TCopyApplicationMonitor.GetLogFileName(): String;
Var
  OurLogFile, LocalOnly, AppDir: string;

  // Finds the users special directory
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MaxChar] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    result := StrPas(path);
  end;

begin
  OurLogFile := LocalAppDataPath;
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';

  LocalOnly := OurLogFile;

  // Now set the application level
  OurLogFile := OurLogFile + ExtractFileName(application.ExeName);
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';
  AppDir := OurLogFile;

  // try to create or use base direcrtory
  if not DirectoryExists(AppDir) then
    if not ForceDirectories(AppDir) then
      OurLogFile := LocalOnly;

  OurLogFile := OurLogFile + 'CPRS_' + IntToStr(GetCurrentProcessID)
  { FormatDateTime('hhmmsszz', now) } + '_CopyPaste.TXT';

  result := OurLogFile;
end;

procedure TCopyApplicationMonitor.LogText(Action, Massage: string);
const
  PadLen: Integer = 18;
VAR
  AddText: TStringList;
  FS: TFileStream;
  Flags: Word;
  X, CenterPad: Integer;
  TextToAdd, Suffix, Suffix2: String;
begin

  if not fLogToFile then
    exit;

  if Trim(fOurLogFile) = '' then
    fOurLogFile := GetLogFileName;

  If FileExists(fOurLogFile) then
    Flags := fmOpenReadWrite
  else
    Flags := fmCreate;

  AddText := TStringList.Create;
  try
    AddText.Text := Massage;

    if UpperCase(Action) = 'TEXT' then
    begin
      Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
        UpperCase(Action) + ']';
      for X := 1 to AddText.Count - 1 do
      begin
        Suffix2 := '[' + IntToStr(X) + ' of ' + IntToStr(AddText.Count - 1) + ']';
        // center text
        CenterPad := round((PadLen - Length(Suffix2)) / 2);
        Suffix2 := StringOfChar(' ', CenterPad) + Suffix2;
        AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
          AddText.Strings[X];
      end;
    end
    else
    begin
      Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
        UpperCase(Action) + ']';
      if AddText.Count > 1 then
      begin
        Suffix2 := FormatDateTime('hh:mm:ss', Now) + ' [' +
          StringOfChar('^', Length(Action)) + ']';
        for X := 1 to AddText.Count - 1 do
          AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
            AddText.Strings[X];
      end;
    end;
    TextToAdd := Suffix.PadRight(PadLen) + ' - ' + AddText.Text;

    // TextToAdd := #13#10 + TextToAdd;
    FS := TFileStream.Create(fOurLogFile, Flags);
    try
      FS.Position := FS.Size;
      FS.Write(TextToAdd[1], Length(TextToAdd) * SizeOf(char));
    finally
      FS.Free;
    end;
  finally
    AddText.Free;
  end;
end;

{$ENDREGION}
{$REGION 'CopyEditMonitor'}

procedure TCopyEditMonitor.LoadPasteText();
var
  CopiedText: TStringList;
  i, X, NumLines, TotalPasted: Integer;
  ProcessLoad: Boolean;
  ClonedRichEdit: TRichEdit;
  PastedString: TStringList;

  function UpdatePasteText(PasteText: TStringList): TStrings;
  begin
    ClonedRichEdit.Text := PasteText.Text;
    result := ClonedRichEdit.Lines;
  end;

  procedure CopyRicheditProperties(dest, Source: TRichEdit);
  var
    ms: TMemoryStream;
    OldName: string;
    rect: TRect;
  begin
    OldName := Source.Name;
    Source.Name := ''; // needed to avoid Name collision
    try
      ms := TMemoryStream.Create;
      try
        ms.WriteComponent(Source);
        ms.Position := 0;
        ms.ReadComponent(dest);
      finally
        ms.Free;
      end;
    finally
      Source.Name := OldName;
    end;
    dest.Visible := false;
    dest.Parent := Source.Parent;

    Source.Perform(EM_GETRECT, 0, Longint(@rect));
    dest.Perform(EM_SETRECT, 0, Longint(@rect));
  end;

  procedure LoadPreviousNewPaste();
  var
   i: Integer;
  begin

    for I := Low(FCopyMonitor.FCPRSClipBoard) to High(FCopyMonitor.FCPRSClipBoard) do
    begin
     if (FCopyMonitor.FCPRSClipBoard[i].SaveForDocument) and (FCopyMonitor.FCPRSClipBoard[i].PasteToIEN = ItemIEN) then
     begin
      SetLength(PasteText, Length(PasteText) + 1);
      PasteText[High(PasteText)].DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
      PasteText[High(PasteText)].New := true;
      PasteText[High(PasteText)].PastedText := TStringList.Create;
      PasteText[High(PasteText)].PastedText.Assign(FCopyMonitor.FCPRSClipBoard[i].CopiedText);
     end;
    end;



  end;

begin

  ClearPasteArray;

  FCopyMonitor.LoadTheProperties;

  // Only display this information on a richedit
  If FMonitorObject is TRichEdit then
  begin
    CopiedText := TStringList.Create();
    try
      ProcessLoad := true;

      if Assigned(FLoadPastedText) then
        FLoadPastedText(self, CopiedText, ProcessLoad);

      if ProcessLoad then
      begin

        if CopiedText.Count > 0 then
        begin
          TotalPasted := StrToIntDef(CopiedText.Values['(0,0)'], -1);
          if FCopyMonitor.fLogToFile then
            If TotalPasted > -1 then
              FCopyMonitor.LogText('LOAD', 'Found ' + IntToStr(TotalPasted) +
                ' existing paste');
          for i := 1 to TotalPasted do
          begin
            PastedString := TStringList.Create;
            try
              NumLines :=
                StrToIntDef(Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'],
                '^', 8), -1);

              for X := 1 to NumLines do
                PastedString.Add(CopiedText.Values['(' + IntToStr(i) + ',' +
                  IntToStr(X) + ')']);

              If TRichEdit(MonitorObject)
                .FindText(StringReplace(Trim(PastedString.Text), #10, '',
                [rfReplaceAll]), 0, Length(TRichEdit(MonitorObject).Text), []
                ) > -1 then
              begin

                SetLength(PasteText, Length(PasteText) + 1);
                PasteText[High(PasteText)].DateTimeOfPaste :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 1);
                PasteText[High(PasteText)].UserWhoPasted :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 2);
                PasteText[High(PasteText)].CopiedFromLocation :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 3);
                PasteText[High(PasteText)].CopiedFromDocument :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 4);
                PasteText[High(PasteText)].CopiedFromAuthor :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 5);
                PasteText[High(PasteText)].CopiedFromPatient :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 6);
                PasteText[High(PasteText)].PastedPercentage :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 7);
                PasteText[High(PasteText)].CopiedFromApplication :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 9);
                PasteText[High(PasteText)].DateTimeOfOriginalDoc :=
                  Piece(CopiedText.Values['(' + IntToStr(i) + ',0)'], '^', 10);
                PasteText[High(PasteText)].PastedText := TStringList.Create;
                PasteText[High(PasteText)].PastedText.Assign(PastedString);

                if FCopyMonitor.fLogToFile then
                  FCopyMonitor.LogText('LOAD', 'Text found in note [' + CopiedText.Values['(' + IntToStr(i) + ',0)'] +']');
              end
              else
              begin
                if FCopyMonitor.fLogToFile then
                  FCopyMonitor.LogText('LOAD', 'Text not found in note [' + CopiedText.Values['(' + IntToStr(i) + ',0)']+']');
              end;

              if Assigned(ClonedRichEdit) then
                FreeAndNil(ClonedRichEdit);

            finally
              PastedString.Free;
            end;

          end;
          //load the paste that have not saved. this clears when a new document is created or saved
          LoadPreviousNewPaste;
          if Length(PasteText) > 0 then
          begin
            If ScreenReaderSystemActive then
              GetScreenReader.Speak('Pasted data exist');
          end;
        end;
      end;
      if Assigned(FVisualMessage) then
        FVisualMessage(self, Show_Panel, [(Length(PasteText) > 0)]);

    finally
      CopiedText.Free;
    end;
  end;
end;

procedure TCopyEditMonitor.SetObjectToMonitor(ACopyObject: TCustomEdit);
begin
  FMonitorObject := nil;

  if Assigned(ACopyObject) then
  begin
    FMonitorObject := ACopyObject;
    HookEditWnd;

  end;
end;

procedure TCopyEditMonitor.WndProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_PASTE) then
  begin
    if Clipboard.HasFormat(CF_TEXT) then
    begin
      PasteToMonitor(nil, true);
    end;
  end
  else if (Msg.Msg = WM_COPY) or (Msg.Msg = WM_CUT) then
  begin
    CopyToMonitor(nil, true, Msg);
  end
  else
    FOldWndProc(Msg);
end;

procedure TCopyEditMonitor.HookEditWnd;
begin
  FOldWndProc := FMonitorObject.WindowProc;
  FMonitorObject.WindowProc := WndProc;
end;

procedure TCopyEditMonitor.CopyToMonitor(Sender: TObject; AllowMonitor: Boolean;
  Msg: TMessage);
begin
  inherited;
  if Assigned(FCopyToMonitor) then
    FCopyToMonitor(self, AllowMonitor);

  if AllowMonitor then
  begin
    CopyMonitor.CopyToCopyPasteClipboard(Trim(MonitorObject.SelText),
      RelatedPackage, ItemIEN);
    if (Msg.Msg = WM_CUT) then
      MonitorObject.SelText := '';
  end else
   FOldWndProc(Msg);
end;

procedure TCopyEditMonitor.PasteToMonitor(Sender: TObject;
  AllowMonitor: Boolean);
Var
  PasteDetails: String;
  OurHandle: HGLOBAL;
  OurPointer: Pointer;
  dwSize: DWORD;
begin
  inherited;
  if Assigned(FPasteToMonitor) then
    FPasteToMonitor(self, AllowMonitor);

  MonitorObject.SelText := Clipboard.AsText;
  if AllowMonitor then
  begin
    if FCopyMonitor.fLogToFile then
      FCopyMonitor.LogText('PASTE', 'Data pasted to IEN(' +
        IntToStr(ItemIEN) + ')');
    PasteDetails := '';
    // Get the details from the clipboard
    if Clipboard.HasFormat(self.FCopyMonitor.CF_CopyPaste) then
    begin
      OurHandle := Clipboard.GetAsHandle(self.FCopyMonitor.CF_CopyPaste);
      OurPointer := GlobalLock(OurHandle);
      dwSize := GlobalSize(OurHandle);
      if dwSize <> 0 then
      begin
        SetString(PasteDetails, PAnsiChar(OurPointer), dwSize - 1);
      end;
      GlobalUnlock(OurHandle);
      if FCopyMonitor.fLogToFile then
        FCopyMonitor.LogText('PASTE', 'Cross session clipboard found');
    end;

    SetLength(FCopyPasteThread, Length(FCopyPasteThread) + 1);
    FCopyPasteThread[High(FCopyPasteThread)] :=
      TCopyPasteThread.Create(Trim(Clipboard.AsText), PasteDetails,
      ItemIEN, self);
{$WARN SYMBOL_DEPRECATED OFF}
    FCopyPasteThread[High(FCopyPasteThread)].Start;
{$WARN SYMBOL_DEPRECATED ON}
    SetLength(PasteText, Length(PasteText) + 1);
    PasteText[High(PasteText)].DateTimeOfPaste :=
      FloatToStr(DateTimeToFMDateTime(Now));
    PasteText[High(PasteText)].New := true;
    PasteText[High(PasteText)].PastedText := TStringList.Create;
    PasteText[High(PasteText)].PastedText.Text := Trim(Clipboard.AsText);

    if Assigned(FVisualMessage) then
      FVisualMessage(self, ShowAndSelect_Panel, [true]);

  end;

end;

procedure TCopyEditMonitor.ClearTheMonitor();
begin
  CopyMonitor.ClearCopyPasteClipboard;
end;

procedure TCopyEditMonitor.SetItemIEN(NewItemIEN: Int64);
begin
  fItemIEN := NewItemIEN;
  // do not show the pannel if there is no note loaded
  if Assigned(FVisualMessage) then
    FVisualMessage(self, Hide_Panel, [(fItemIEN < 1)]);

end;

procedure TCopyEditMonitor.SaveTheMonitor(ItemID: Integer);
var
  SaveList: TStringList;
  i, ReturnCursor: Integer;
  CanContinue: Boolean;
begin
  SaveList := TStringList.Create;
  try
    inherited;

    CanContinue := false;
    ReturnCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      while not CanContinue do
      begin
        CanContinue := true;
        for i := Low(FCopyPasteThread) to High(FCopyPasteThread) do
        begin
          if FCopyPasteThread[i].TheadOwner = ItemID then
          begin
            if FCopyMonitor.fLogToFile then
             FCopyMonitor.LogText('SAVE', 'Thread still exist, can not save');
            CanContinue := false;
            Break;
          end;
        end;
      end;
    finally
      Screen.Cursor := ReturnCursor;
    end;

    ItemIEN := ItemID;
    if FCopyMonitor.fLogToFile then
      FCopyMonitor.LogText('SAVE', 'Saving paste data for IEN(' +
        IntToStr(ItemID) + ')');
    CopyMonitor.SaveCopyPasteClipboard(self, SaveList);

    if Assigned(FSaveTheMonitor) then
      FSaveTheMonitor(self, SaveList);

  finally
    SaveList.Free;
  end;
end;

destructor TCopyEditMonitor.Destroy;
var
  i: Integer;
begin
  if Assigned(FMonitorObject) then
  begin
    FMonitorObject.WindowProc := FOldWndProc;
    FMonitorObject := nil;
  end;
  ClearPasteArray;

  for i := Low(FCopyPasteThread) to High(FCopyPasteThread) do
    FCopyPasteThread[i].Terminate;
  SetLength(FCopyPasteThread, 0);
  inherited;
end;

procedure TCopyEditMonitor.ClearPasteArray();
Var
  i: Integer;
begin

  for i := high(PasteText) downto Low(PasteText) do
    PasteText[i].PastedText.Free;

  SetLength(PasteText, 0);
end;

{$ENDREGION}
{$REGION 'Misc'}

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if i < PieceNum then
    result := ''
  else
    SetString(result, Strt, Next - Strt);
end;

function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
var
  X: string;
  Y, m, d, h, n, S: Integer;

  function CharAt(const X: string; APos: Integer): char;
  { returns a character at a given position in a string or the null character if past the end }
  begin
    if Length(X) < APos then
      result := #0
    else
      result := X[APos];
  end;

  function TrimFormatCount: Integer;
  { delete repeating characters and count how many were deleted }
  var
    c: char;
  begin
    result := 0;
    c := AFormat[1];
    repeat
      Delete(AFormat, 1, 1);
      Inc(result);
    until CharAt(AFormat, 1) <> c;
  end;

begin { FormatFMDateTime }
  result := '';
  if not(ADateTime > 0) then
    exit;
  X := FloatToStrF(ADateTime, ffFixed, 15, 6) + '0000000';
  Y := StrToIntDef(Copy(X, 1, 3), 0) + 1700;
  m := StrToIntDef(Copy(X, 4, 2), 0);
  d := StrToIntDef(Copy(X, 6, 2), 0);
  h := StrToIntDef(Copy(X, 9, 2), 0);
  n := StrToIntDef(Copy(X, 11, 2), 0);
  S := StrToIntDef(Copy(X, 13, 2), 0);
  while Length(AFormat) > 0 do
  begin
    case UpCase(AFormat[1]) of
      '"':
        begin // literal
          Delete(AFormat, 1, 1);
          while not(CharInSet(CharAt(AFormat, 1), [#0, '"'])) do
          begin
            result := result + AFormat[1];
            Delete(AFormat, 1, 1);
          end;
          if CharAt(AFormat, 1) = '"' then
            Delete(AFormat, 1, 1);
        end;
      'D':
        case TrimFormatCount of // day/date
          1:
            if d > 0 then
              result := result + IntToStr(d);
          2:
            if d > 0 then
              result := result + FormatFloat('00', d);
        end;
      'H':
        case TrimFormatCount of // hour
          1:
            result := result + IntToStr(h);
          2:
            result := result + FormatFloat('00', h);
        end;
      'M':
        case TrimFormatCount of // month
          1:
            if m > 0 then
              result := result + IntToStr(m);
          2:
            if m > 0 then
              result := result + FormatFloat('00', m);
          3:
            if m in [1 .. 12] then
              result := result + MONTH_NAMES_SHORT[m];
          4:
            if m in [1 .. 12] then
              result := result + MONTH_NAMES_LONG[m];
        end;
      'N':
        case TrimFormatCount of // minute
          1:
            result := result + IntToStr(n);
          2:
            result := result + FormatFloat('00', n);
        end;
      'S':
        case TrimFormatCount of // second
          1:
            result := result + IntToStr(S);
          2:
            result := result + FormatFloat('00', S);
        end;
      'Y':
        case TrimFormatCount of // year
          2:
            if Y > 0 then
              result := result + Copy(IntToStr(Y), 3, 2);
          4:
            if Y > 0 then
              result := result + IntToStr(Y);
        end;
    else
      begin // other
        result := result + AFormat[1];
        Delete(AFormat, 1, 1);
      end;
    end; { case }
  end;
end; { FormatFMDateTime }

function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
var
  Y, m, d, h, n, S, l: Word;
  DatePart, TimePart: Integer;
begin
  DecodeDate(ADateTime, Y, m, d);
  DecodeTime(ADateTime, h, n, S, l);
  DatePart := ((Y - 1700) * 10000) + (m * 100) + d;
  TimePart := (h * 10000) + (n * 100) + S;
  result := DatePart + (TimePart / 1000000);
end;

function FilteredString(const X: string; ATabWidth: Integer = 8): string;
var
  i, j: Integer;
  c: char;
begin
  result := '';
  for i := 1 to Length(X) do
  begin
    c := X[i];
    if c = #9 then
    begin
      for j := 1 to (ATabWidth - (Length(result) mod ATabWidth)) do
        result := result + ' ';
    end
    else if CharInSet(c, [#32 .. #127]) then
    begin
      result := result + c;
    end
    else if CharInSet(c, [#10, #13, #160]) then
    begin
      result := result + ' ';
    end
    else if CharInSet(c, [#128 .. #159]) then
    begin
      result := result + '?';
    end
    else if CharInSet(c, [#161 .. #255]) then
    begin
      result := result + X[i];
    end;
  end;

  if Copy(result, Length(result), 1) = ' ' then
    result := TrimRight(result) + ' ';
end;

{$ENDREGION}
{$REGION 'Thread'}

constructor TCopyPasteThread.Create(PasteText, PasteDetails: String;
  ItemIEN: Integer; EditMonitor: TComponent);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  fEditMonitor := EditMonitor;
  fPasteText := PasteText;
  fPasteDetails := PasteDetails;
  fItemIEN := ItemIEN;
  if TCopyEditMonitor(fEditMonitor).FCopyMonitor.fLogToFile then
   TCopyEditMonitor(fEditMonitor).FCopyMonitor.LogText('THREAD', 'Thread created');
end;

destructor TCopyPasteThread.Destroy;
var
  i: Integer;

  procedure DeleteX(const Index: Cardinal);
  var
    ALength: Cardinal;
    TailElements: Cardinal;
  begin
    with TCopyEditMonitor(fEditMonitor) do
    begin
      ALength := Length(FCopyPasteThread);
      Assert(ALength > 0);
      Assert(Index < ALength);
      // Finalize(FCopyPasteThread[Index]);
      TailElements := ALength - Index;
      if TailElements > 0 then
        Move(FCopyPasteThread[Index + 1], FCopyPasteThread[Index],
          SizeOf(FCopyPasteThread) * TailElements);
      // Initialize(FCopyPasteThread[ALength - 1]);
      SetLength(FCopyPasteThread, ALength - 1);
    end;
  end;

begin
  inherited;
  with TCopyEditMonitor(fEditMonitor) do
  begin

    for i := high(FCopyPasteThread) downto low(FCopyPasteThread) do
    begin
      if FCopyPasteThread[i] = self then
      begin
        DeleteX(i);
        if FCopyMonitor.fLogToFile then
         FCopyMonitor.LogText('THREAD', 'Thread deleted');
      end;
    end;

  end;

end;

procedure TCopyPasteThread.Execute;
begin
  if TCopyEditMonitor(fEditMonitor).FCopyMonitor.fLogToFile then
   TCopyEditMonitor(fEditMonitor).FCopyMonitor.LogText('THREAD', 'Looking for matches');
  TCopyEditMonitor(fEditMonitor).FCopyMonitor.PasteToCopyPasteClipboard
    (fPasteText, fPasteDetails, fItemIEN);
end;

{$ENDREGION}
{$REGION 'TcpyPasteDetails'}

procedure TCopyPasteDetails.VisualMesageCenter(Sender: TObject;
  const CPmsg: Cardinal; CPVars: Array of Variant);
begin
  Try
    case CPmsg of
      Show_Panel:
        ShowInfoPanel(Boolean(CPVars[0]));
      ShowAndSelect_Panel:
        Begin
          ShowInfoPanel(Boolean(CPVars[0]));

          if FLastInfoboxHeight < 100 then
            FLastInfoboxHeight := 100;
          if FInfoboxCollapsed then
          begin
            CloseInfoPanel(self);
          end
          else
            self.Height := FLastInfoboxHeight;

          // Autoselect the pasted text
          FInfoSelector.ItemIndex := 0;
          lbSelectorClick(FInfoSelector);
          FInfoSelector.SetFocus;
        End;
       Hide_Panel: If Boolean(CPVars[0]) then ShowInfoPanel(false);
    end;

  Except
    on E: Exception do
    begin
      raise Exception.Create('Exception class name = ' + E.ClassName + #13 +
        'Exception message = ' + E.Message);
    end;

  End;
end;

procedure TCopyPasteDetails.InfoPanelResize(Sender: TObject);
begin
  if FSuspendResize then
    exit;
  if self.Height > self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ú'; // up
    FInfoboxCollapsed := false;
  end;
  if self.Height = self.Constraints.MinHeight then
  begin
    FCollapseBtn.Caption := 'Ù'; // up
    FInfoboxCollapsed := true;
  end
  else
    FLastInfoboxHeight := self.Height;
end;

Procedure TCopyPasteDetails.ReloadInfoPanel();
Var
  i: Integer;
begin
  FInfoMessage.Text := '<-- Please select the desired paste date';
  With FInfoSelector, EditMonitor do
  begin
    TabOrder := FMonitorObject.TabOrder + 1;
    Clear;
    for i := High(PasteText) downto Low(PasteText) do
    begin
      if PasteText[i].New then
        PasteText[i].InfoPanelIndex := Items.Add('new')
      else
        PasteText[i].InfoPanelIndex :=
          Items.Add(FormatFMDateTime('mmm dd,yyyy hh:nn',
          StrToFloat(PasteText[i].DateTimeOfPaste)));
    end;
    FInfoMessage.TabOrder := FMonitorObject.TabOrder + 2;
  end;
end;

procedure TCopyPasteDetails.CloseInfoPanel(Sender: TObject);
begin
  FSuspendResize := true;
  if FInfoboxCollapsed then
  begin
    if FLastInfoboxHeight > 0 then
      self.Height := FLastInfoboxHeight
    else
      self.Height := 100;
    FCollapseBtn.Caption := 'Ú'; // down
  end
  else
  begin
    FLastInfoboxHeight := self.Height;
    self.Height := self.Constraints.MinHeight;
    FCollapseBtn.Caption := 'Ù'; // up
  end;
  FInfoboxCollapsed := Not FInfoboxCollapsed;
  FSuspendResize := false;
end;

procedure TCopyPasteDetails.ShowInfoPanel(Toggle: Boolean);
begin
  SendMessage(Parent.Handle, WM_SETREDRAW, 0, 0);
  try
    if Toggle then
    begin
      self.Visible := true;
      // FInfoSpliter.Visible := true;
      // FInfoSpliter.Top := self.Top;
      ReloadInfoPanel;
      if Assigned(FShow) then
        FShow(self);
    end
    else
    begin
      if Assigned(self) then
      begin
        self.Visible := false;
        // FInfoSpliter.Visible := false;
        if Assigned(FHide) then
          FHide(self);
      end;

    end;
  finally
    SendMessage(Parent.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(Parent.Handle, nil, 0, RDW_ERASE or RDW_FRAME or
      RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

procedure TCopyPasteDetails.pnlMessageExit(Sender: TObject);
VAr
  Format: CHARFORMAT2;
  ResetMask: Integer;
begin
  with EditMonitor do
  begin
    ResetMask := TRichEdit(FMonitorObject).Perform(EM_GETEVENTMASK, 0, 0);
    TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, 0);
    TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(false), 0);
    try
      TRichEdit(FMonitorObject).SelStart := 0;
      TRichEdit(FMonitorObject).SelLength :=
        Length(TRichEdit(FMonitorObject).Text);
      // Set the font
      TRichEdit(FMonitorObject).SelAttributes.Style := [];
      // Set the background color
      Format.cbSize := SizeOf(Format);
      Format.dwMask := CFM_BACKCOLOR;
      if TRichEdit(MonitorObject).Color > 0 then
        Format.crBackColor := TRichEdit(MonitorObject).Color
      else
        Format.crBackColor := clWhite;

      TRichEdit(FMonitorObject).Perform(EM_SETCHARFORMAT, SCF_SELECTION,
        Longint(@Format));
      TRichEdit(FMonitorObject).SelLength := 0;

      if not TRichEdit(FMonitorObject).ReadOnly and TRichEdit(FMonitorObject).Enabled
      then
        TRichEdit(FMonitorObject).SelStart := FPasteCurPos;

    finally
      TRichEdit(FMonitorObject).Perform(WM_SETREDRAW, Ord(true), 0);
      InvalidateRect(TRichEdit(FMonitorObject).Handle, NIL, true);
      TRichEdit(FMonitorObject).Perform(EM_SETEVENTMASK, 0, ResetMask);
    end;
  end;
end;

procedure TCopyPasteDetails.lbSelectorClick(Sender: TObject);
var
  i, iii, CharCnt, X, ReturnFSize: Integer;
begin
  with EditMonitor do
  begin
    FInfoMessage.Clear;
    for i := Low(PasteText) to High(PasteText) do
    begin
      if PasteText[i].InfoPanelIndex = TListBox(Sender).ItemIndex then
      begin
        FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
        ReturnFSize := FInfoMessage.SelAttributes.Size;
        FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
        FInfoMessage.SelText := 'Source (from)';
        FInfoMessage.Lines.Add('');
        FInfoMessage.SelAttributes.Size := ReturnFSize;

        if PasteText[i].New then
        begin
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := 'More details will be provided once saved';
          FInfoMessage.Lines.Add('');
        end;

        if PasteText[i].DateTimeOfOriginalDoc <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Document created on: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
            StrToFloat(PasteText[i].DateTimeOfOriginalDoc));
          FInfoMessage.Lines.Add('');
        end;

        if PasteText[i].CopiedFromLocation <> '' then
        begin
          if StrToIntDef(Piece(PasteText[i].CopiedFromLocation, ';', 1), -1) = -1
          then
          begin
            CharCnt := 1;
            for iii := 0 to Length(PasteText[i].CopiedFromLocation) do
              if PasteText[i].CopiedFromLocation[iii] = ';' then
                Inc(CharCnt);
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Patient: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText := Piece(PasteText[i].CopiedFromLocation,
              ';', CharCnt);
            FInfoMessage.Lines.Add('');
          end
          else if PasteText[i].CopiedFromPatient <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'Patient: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText :=
              Piece(PasteText[i].CopiedFromPatient, ';', 2);
            FInfoMessage.Lines.Add('');
          end;
        end
        else if PasteText[i].CopiedFromPatient <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Patient: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := Piece(PasteText[i].CopiedFromPatient, ';', 2);
          FInfoMessage.Lines.Add('');
        end;

        if PasteText[i].CopiedFromDocument <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Title: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := PasteText[i].CopiedFromDocument;
          FInfoMessage.Lines.Add('');
        end;

        if Piece(PasteText[i].CopiedFromAuthor, ';', 2) <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Author: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := Piece(PasteText[i].CopiedFromAuthor, ';', 2);
          FInfoMessage.Lines.Add('');
        end;

        if PasteText[i].CopiedFromLocation <> '' then
        begin
          if StrToIntDef(Piece(PasteText[i].CopiedFromLocation, ';', 1), -1)
            <> -1 then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'ID: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText :=
              Piece(PasteText[i].CopiedFromLocation, ';', 1);
            FInfoMessage.Lines.Add('');
          end;
          if Piece(PasteText[i].CopiedFromLocation, ';', 2) <> '' then
          begin
            FInfoMessage.SelAttributes.Style := [fsBold];
            FInfoMessage.SelText := 'From: ';
            FInfoMessage.SelAttributes.Style := [];
            FInfoMessage.SelText :=
              Piece(PasteText[i].CopiedFromLocation, ';', 2);
            FInfoMessage.Lines.Add('');
          end;
        end;

        if PasteText[i].CopiedFromApplication <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Application: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := PasteText[i].CopiedFromApplication;
          FInfoMessage.Lines.Add('');
        end;

        FInfoMessage.Lines.Add('');

        FInfoMessage.SelAttributes.Style := [fsBold, fsUnderline];
        ReturnFSize := FInfoMessage.SelAttributes.Size;
        FInfoMessage.SelAttributes.Size := ReturnFSize + 2;
        FInfoMessage.SelText := 'Pasted Info';
        FInfoMessage.Lines.Add('');
        FInfoMessage.SelAttributes.Size := ReturnFSize;

        if PasteText[i].DateTimeOfPaste <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Date: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := FormatFMDateTime('mmm dd,yyyy hh:nn',
            StrToFloat(PasteText[i].DateTimeOfPaste));
          FInfoMessage.Lines.Add('');
        end;

        if Piece(PasteText[i].UserWhoPasted, ';', 2) <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'User: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := Piece(PasteText[i].UserWhoPasted, ';', 2);
          FInfoMessage.Lines.Add('');
        end;

        if PasteText[i].PastedPercentage <> '' then
        begin
          FInfoMessage.SelAttributes.Style := [fsBold];
          FInfoMessage.SelText := 'Percentage: ';
          FInfoMessage.SelAttributes.Style := [];
          FInfoMessage.SelText := PasteText[i].PastedPercentage;
          FInfoMessage.Lines.Add('');
        end;

        FInfoMessage.SelAttributes.Style := [fsBold];
        FInfoMessage.SelText := 'Pasted Text: ';
        FInfoMessage.SelAttributes.Style := [];
        for X := 0 to PasteText[i].PastedText.Count - 1 do
          FInfoMessage.Lines.Add(PasteText[i].PastedText[X]);

        HighLightInfoPanel(CopyMonitor.HighlightColor, CopyMonitor.MatchStyle,
          CopyMonitor.MatchHighlight, PasteText[i].PastedText.Text);

        FInfoMessage.SelStart := 0;
        Break;
      end;

    end;
  end;
end;

procedure TCopyPasteDetails.HighLightInfoPanel(Color: TColor;
  Style: TFontStyles; ShowHighlight: Boolean; PasteText: String);
var
  CharPos, CharPos2, endChars, ResetMask: Integer;
  SearchOpts: TSearchTypes;
  Format: CHARFORMAT2;
  SearchString: string;
  isSelectionHidden: Boolean;

  Procedure CenterPasteText(PasteLine: Integer);
  Var
    TopLine, VisibleLines, FirstLine: Integer;
    // TextHeight: Integer;
  begin
    FirstLine := TRichEdit(EditMonitor.FMonitorObject)
      .Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
    VisibleLines := round(TRichEdit(EditMonitor.FMonitorObject).ClientHeight /
      Abs(TRichEdit(EditMonitor.FMonitorObject).font.Height));

    if VisibleLines <= 1 then
      TopLine := PasteLine
    else
      TopLine := Max(PasteLine - round((VisibleLines / 2)) + 1, 0);

    if FirstLine <> TopLine then
      TRichEdit(EditMonitor.FMonitorObject).Perform(EM_LINESCROLL, 0,
        TopLine - FirstLine);

  end;

begin
  ResetMask := TRichEdit(EditMonitor.FMonitorObject)
    .Perform(EM_GETEVENTMASK, 0, 0);
  TRichEdit(EditMonitor.FMonitorObject).Perform(EM_SETEVENTMASK, 0, 0);
  TRichEdit(EditMonitor.FMonitorObject).Perform(WM_SETREDRAW, Ord(false), 0);
  try
    // Clear out the variables
    CharPos := 0;
    SearchOpts := [];
    endChars := Length(TRichEdit(EditMonitor.FMonitorObject).Text);

    pnlMessageExit(self);
    repeat

      SearchString := StringReplace(Trim(PasteText), #10, '', [rfReplaceAll]);

      // find the text and save the position
      CharPos2 := TRichEdit(EditMonitor.FMonitorObject).FindText(SearchString,
        CharPos, endChars, SearchOpts);
      CharPos := CharPos2 + 1;
      if CharPos = 0 then
        Break;
      FPasteCurPos := CharPos2;
      // Select the word
      TRichEdit(EditMonitor.FMonitorObject).SelStart := CharPos2;
      TRichEdit(EditMonitor.FMonitorObject).SelLength := Length(SearchString);

      // Set the font
      TRichEdit(EditMonitor.FMonitorObject).SelAttributes.Style := Style;

      if ShowHighlight then
      begin
        // Set the background color
        Format.cbSize := SizeOf(Format);
        Format.dwMask := CFM_BACKCOLOR;
        Format.crBackColor := Color;
        TRichEdit(EditMonitor.FMonitorObject).Perform(EM_SETCHARFORMAT,
          SCF_SELECTION, Longint(@Format));
      end;

      isSelectionHidden := TRichEdit(EditMonitor.FMonitorObject).HideSelection;
      try
        TRichEdit(EditMonitor.FMonitorObject).HideSelection := false;
        TRichEdit(EditMonitor.FMonitorObject).SelLength := 1;
        // Scroll to caret
        CenterPasteText(TRichEdit(EditMonitor.FMonitorObject)
          .Perform(EM_LINEFROMCHAR, TRichEdit(EditMonitor.FMonitorObject)
          .SelStart, 0));

      finally
        TRichEdit(EditMonitor.FMonitorObject).HideSelection :=
          isSelectionHidden;
      end;
      TRichEdit(EditMonitor.FMonitorObject).SelLength := 0;
    until CharPos = 0;

  finally
    TRichEdit(EditMonitor.FMonitorObject).Perform(WM_SETREDRAW, Ord(true), 0);
    InvalidateRect(TRichEdit(EditMonitor.FMonitorObject).Handle, NIL, true);
    TRichEdit(EditMonitor.FMonitorObject).Perform(EM_SETEVENTMASK, 0,
      ResetMask);
  end;
end;

constructor TCopyPasteDetails.Create(AOwner: TComponent);
var
  TopPanel: TPanel;
begin
  inherited;
  With self do
  begin
    Caption := '';
    Height := 100;
    BevelInner := bvRaised;
    BorderStyle := bsSingle;
    TabStop := false;
    ShowCaption := false;
    Visible := true;
  end;

  TopPanel := TPanel.Create(self);
  With TopPanel do
  begin
    Name := 'PasteInfoTopPanel';
    Parent := self;
    ShowCaption := false;
    align := altop;
    BevelOuter := bvNone;
    AutoSize := true;
    Height := 20;
  end;

  FCollapseBtn := TCollapseBtn.Create(self);
  with FCollapseBtn do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoCollapseBtn';
    Parent := TopPanel;
    align := alRight;
    Width := 17;
    Caption := 'Ú';
    font.Name := 'Wingdings';
    TabStop := false;
  end;

  With TLabel.Create(self) do
  begin
    Name := 'PasteInfoLabel';
    Parent := TopPanel;
    align := alClient;
    Caption := 'Pasted Data';
    font.Style := [fsBold];
  end;

  self.Constraints.MinHeight := TopPanel.Height + 10;

  FInfoSelector := TSelectorBox.Create(self);
  With FInfoSelector do
  begin
    SetSubComponent(true);
    Name := 'PasteInfo';
    Parent := self;
    Width := 117;
    align := alLeft;
    ItemHeight := 13;
    TabStop := true;
    AlignWithMargins := true;
  end;

  FInfoMessage := TRichEdit.Create(self);
  With FInfoMessage do
  begin
    SetSubComponent(true);
    Name := 'PasteInfoMessage';
    Parent := self;
    align := alClient;
    AlignWithMargins := true;
    ReadOnly := true;
    ScrollBars := ssBoth;
    TabStop := true;
    WantReturns := false;
    WordWrap := false;
    Text := '<-- Please select the desired paste date';
  end;
  fEditMonitor := TCopyEditMonitor.Create(self);
  fEditMonitor.SetSubComponent(true);
  fEditMonitor.FVisualMessage := VisualMesageCenter;
  FInfoboxCollapsed := false;
end;

procedure TCopyPasteDetails.DoExit;
begin
  inherited;
  pnlMessageExit(self);
end;

procedure TCopyPasteDetails.Resize;
begin
  inherited;
  InfoPanelResize(self);
end;

{$ENDREGION}
{$REGION 'TCollapseBtn'}

procedure TCollapseBtn.Click;
begin
  inherited;
  TCopyPasteDetails(self.Owner).CloseInfoPanel(self);
end;

{$ENDREGION}
{$REGION 'TSelectorBox'}

procedure TSelectorBox.Click;
begin
  inherited;
  TCopyPasteDetails(self.Owner).lbSelectorClick(self);
end;

{$ENDREGION}

end.
