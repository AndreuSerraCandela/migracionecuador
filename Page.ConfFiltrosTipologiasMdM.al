#pragma implicitwith disable
page 75008 "Conf.Filtros Tipologias MdM"
{
    ApplicationArea = all;
    Caption = 'Campos Filtro Tipologias MdM';
    PageType = List;
    SourceTable = "Conf.Filtros Tipologias MdM";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = wEditable;
                field(Id; rec.Id)
                {
                }
                field(Tipo; rec.Tipo)
                {
                }
                field("Valor Id"; rec."Valor Id")
                {
                }
                field(GetIdName; rec.GetIdName)
                {
                    Caption = 'Nombre';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if rCampos.FindLast then
            Rec.Id := rCampos.Id + 1
        else
            Rec.Id := 1;
    end;

    trigger OnOpenPage()
    begin
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
    end;

    var
        cFunMdm: Codeunit "Funciones MdM";
        rCampos: Record "Conf.Filtros Tipologias MdM";
        wEditable: Boolean;
}

#pragma implicitwith restore

