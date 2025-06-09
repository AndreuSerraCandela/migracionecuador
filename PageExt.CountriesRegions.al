pageextension 50002 pageextension50002 extends "Countries/Regions"
{
    layout
    {
        modify(Control1)
        {
            Editable = true;
        }
        // addafter("SAT Country Code")
        // {
        //     field(Bloqueado; rec.Bloqueado)
        //     {
        //         ApplicationArea = Basic, Suite;
        //         Caption = 'Blocked';
        //         Visible = false;
        //     }
        // }
    }

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;


    trigger OnDeleteRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption); // MdM
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption); // MdM
    end;

    trigger OnModifyRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption); // MdM
    end;

    trigger OnOpenPage()
    begin
        // <MdM>
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
        // </MdM>
    end;
}

