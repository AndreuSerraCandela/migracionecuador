pageextension 50129 pageextension50129 extends Languages
{
    layout
    {
        modify(Control2)
        {
            Editable = wEditable;
        }
        modify("Windows Language ID")
        {
            ToolTip = 'Specifies the ID of the Windows language associated with the language code you have set up in this line.';
        }
        modify("Windows Language Name")
        {
            ToolTip = 'Specifies if you enter an ID in the Windows Language ID field.';
        }
        addafter("Windows Language Name")
        {
            field(Bloqueado; rec.Bloqueado)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Blocked';
                Visible = false;
            }
        }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;


    trigger OnDeleteRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(rec.TableCaption); // MdM
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(rec.TableCaption); // MdM
    end;

    trigger OnModifyRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(rec.TableCaption); // MdM
    end;

    trigger OnOpenPage()
    begin
        // <MdM>
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
        // </MdM>
    end;
}

