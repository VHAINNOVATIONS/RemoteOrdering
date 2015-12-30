unit MultipleOrderedDrugs;
{
================================================================================
*	File:  MultipleDrugs.PAS
*
*	Application:  Bar Code Medication Administration
*	Revision:     $Revision: 12 $  $Modtime: 11/02/01 1:53p $
*
*	Description:  This is a form for selecting one ordered drug from a list of
*               ordered drugs for a MedOrder.  This form will attempt to resize
*               itself, at creation time, correponding to the number of lines
*               and the length of the longest line in the listbox.
================================================================================
}
interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, StdCtrls, Buttons;

const
	MAXCHARS = 80;
	MINCHARS = 40;
	MAXLINES = 10;
	MINLINES = 5;

type
	TfrmMultipleOrderedDrugs = class(TForm)
		pnlButton: TPanel;
		lbxSelectList: TListBox;
		Label1: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
		procedure FormCreate(Sender: TObject);
		(*
				Clears the lbxSelectList listbox.
		*)

		procedure FormShow(Sender: TObject);
		(*
				Sets the initial size of the form according to the number of lines and
				the length of the longest line of text in the listbox.
		*)

		procedure FormResize(Sender: TObject);
		(*
				Resets the positions of the OK and Cancel buttons whenever the the form
				is resized, to ensure that they will always be visible.
		*)

		procedure btnOKClick(Sender: TObject);
		(*
				If an item has been selected from the list,	modalResult is set to
				lbxSelectList.ItemIndex + 100, closing the form.
		*)

	private
		{ Private declarations }
	public
		{ Public declarations }
	end;

var
	frmMultipleOrderedDrugs: TfrmMultipleOrderedDrugs;

implementation
{$R *.DFM}
uses
	Math, BCMA_Common;

procedure TfrmMultipleOrderedDrugs.FormResize(Sender: TObject);
begin
	btnOK.Width := btnCancel.Width;
	btnOK.Left := pnlButton.ClientWidth - (btnOK.Width + self.BorderWidth) * 2;
	btnCancel.Left := pnlButton.ClientWidth - (btnCancel.Width + self.BorderWidth);
end;

procedure TfrmMultipleOrderedDrugs.FormShow(Sender: TObject);
(*
	Setting the initial form size.
		Width = 80 < width of the longest string in ReportText < 130 characters.
		Height = 5 < ReportText.lines.Count < 40 lines.
*)
var
	ii,
	nChars:	integer;
begin
	nChars := MINCHARS;
	with lbxSelectList do
		for ii := 0 to items.Count-1 do
			if nChars < length(items[ii]) then
				nChars := length(items[ii]);

	self.ClientWidth := getTextWidth(min(MAXCHARS, nChars), lbxSelectList.font) +
											self.BorderWidth * 2 + 25;
	self.ClientHeight :=	getTextHeight(lbxSelectList.font) *
												max(MINLINES, min(40, lbxSelectList.items.Count+1)) +
												self.BorderWidth * 2 + pnlButton.height + 25;

	lbxSelectList.setFocus;
end;

procedure TfrmMultipleOrderedDrugs.btnOKClick(Sender: TObject);
begin
	with lbxSelectList do
		if ItemIndex > -1 then
			//modalResult := 100 + ItemIndex;
      modalResult := 100 + integer(Items.Objects[ItemIndex]);
end;

procedure TfrmMultipleOrderedDrugs.FormCreate(Sender: TObject);
begin
	lbxSelectList.clear;
end;

end.
