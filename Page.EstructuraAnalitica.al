#pragma implicitwith disable
page 75002 "Estructura Analitica"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'Analytical Structure';
    PageType = List;
    SourceTable = "Estructura Analitica";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = wEditable;
                field(Codigo; rec.Codigo)
                {
                }
                field(Nivel; rec.Nivel)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field(Blocked; rec.Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Rec.TableCaption);
    end;

    trigger OnOpenPage()
    begin
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
    end;

    var
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;
}

#pragma implicitwith restore

