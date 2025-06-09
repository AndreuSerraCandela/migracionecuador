page 75011 "Tipo Filtros Tipologia MdM"
{
    ApplicationArea = all;
    // OJO. Tener en cuenta que es una tabla temporal

    Editable = false;
    PageType = List;
    SourceTable = "Tipo Filtros Tipo. MdM Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                }
                field("Code"; rec.Code)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RellenaTabla(rec.GetRangeMin(Tipo));
    end;

    var
        cFunMdM: Codeunit "Funciones MdM";


    procedure RellenaTabla(pwTipo: Option Dimension,"Dato MdM",Otros)
    var
        lwN: Integer;
        lrTmpDts: Record "Datos MDM" temporary;
    begin
        // RellenaTabla

        rec.DeleteAll;

        case pwTipo of
            pwTipo::Dimension:
                begin
                    for lwN := 0 to cFunMdM.GetTotalGestDim - 1 do begin
                        AddReg(pwTipo, lwN, cFunMdM.GetDimNameField(lwN));
                    end;
                end;
            pwTipo::"Dato MdM":
                begin
                    for lwN := 0 to lrTmpDts.TotalTipos - 1 do begin
                        lrTmpDts.Tipo := lwN;
                        AddReg(pwTipo, lwN, Format(lrTmpDts.Tipo));
                    end;
                end;
            pwTipo::Otros:
                begin
                    for lwN := 1 to cFunMdM.GetTotalOtrosOptions do begin
                        AddReg(pwTipo, lwN, cFunMdM.GetOtrosName(lwN));
                    end;
                end;
        end;
    end;


    procedure AddReg(pwTipo: Integer; pwId: Integer; pwCode: Text)
    begin
        // AddReg

        rec.Init;
        rec.Id := pwId;
        rec.Code := pwCode;
        rec.Tipo := pwTipo;
        rec.Insert;
    end;
}

