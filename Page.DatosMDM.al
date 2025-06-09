#pragma implicitwith disable
page 75001 "Datos MDM"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'MdM Data';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Datos MDM";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Control1000000008)
            {
                Caption = 'Tipo';
                ShowCaption = false;
                field(pTtipo; wTipo)
                {
                    Caption = 'Tipo';
                    Editable = wEditable;
                    Importance = Promoted;
                    OptionCaption = 'Tipo Producto,Soporte,Editora,Nivel,Plan Editorial,Autor,Ciclo,Linea,Asignatura,Grado,Sello,Edición,Estado,Campaña';

                    trigger OnValidate()
                    begin
                        ActualizaTipo;
                    end;
                }
            }
            repeater(Group)
            {
                Editable = wEditable;
                field(Tipo; rec.Tipo)
                {
                    OptionCaption = '', Locked = true;
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Codigo Relacionado"; rec."Codigo Relacionado")
                {
                    Visible = false;
                }
                field(Bloqueado; rec.Bloqueado)
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
        wEditable := cFunMdm.GetEditableErr(Format(wTipo));
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Format(wTipo));
    end;

    trigger OnModifyRecord(): Boolean
    begin
        wEditable := cFunMdm.GetEditableErr(Format(wTipo));
    end;

    trigger OnOpenPage()
    begin

        if Rec.GetFilter(Tipo) <> '' then
            wTipo := Rec.GetRangeMin(Tipo);
        ActualizaTipo;
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;
    end;

    var
        wTipo: Option "Tipo Producto",Soporte,Editora,Nivel,"Plan Editorial",Autor,Ciclo,Linea,Asignatura,Grado,Sello,"Edición",Estado,"Campaña";
        cFunMdm: Codeunit "Funciones MdM";
        wEditable: Boolean;


    procedure ActualizaTipo()
    begin
        // ActualizaTipo

        Rec.FilterGroup(2);
        Rec.SetRange(Tipo, wTipo);
        Rec.FilterGroup(0);
        CurrPage.Update(Rec.Codigo <> '');
    end;
}

#pragma implicitwith restore

