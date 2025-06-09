page 75012 "Valores Filtros Tipologia MdM"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Valores Filtros Tipologia MdM";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; rec.Code)
                {
                }
                field(Description; rec.Description)
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
        RellenaTabla(rec.GetRangeMin("Id Filtro"));
    end;

    var
        wId: Integer;
        cFunMdM: Codeunit "Funciones MdM";


    procedure RellenaTabla(pwIdFiltro: Integer)
    var
        lrFiltroTipo: Record "Conf.Filtros Tipologias MdM";
        lrDatosMdM: Record "Datos MDM";
        lwCodDim: Code[20];
        lrValDim: Record "Dimension Value";
        lrCodGrProd: Record "Item Category";
    //Table 'Product Group' is removed. Reason: Product Groups became first level children of Item Categories..
    begin
        // RellenaTabla

        rec.DeleteAll;
        wId := 0;

        if lrFiltroTipo.Get(pwIdFiltro) then begin
            case lrFiltroTipo.Tipo of
                lrFiltroTipo.Tipo::Dimension:
                    begin
                        lwCodDim := cFunMdM.GetDimCode(lrFiltroTipo."Valor Id", true);
                        Clear(lrValDim);
                        lrValDim.SetRange("Dimension Code", lwCodDim);
                        if lrValDim.FindSet then begin
                            repeat
                                AddReg(pwIdFiltro, lrValDim.Code, lrValDim.Name);
                            until lrValDim.Next = 0;
                        end;
                    end;
                lrFiltroTipo.Tipo::"Dato MdM":
                    begin
                        Clear(lrDatosMdM);
                        lrDatosMdM.SetRange(Tipo, lrFiltroTipo."Valor Id");
                        if lrDatosMdM.FindSet then begin
                            repeat
                                AddReg(pwIdFiltro, lrDatosMdM.Codigo, lrDatosMdM.Descripcion);
                            until lrDatosMdM.Next = 0;
                        end;
                    end;
                lrFiltroTipo.Tipo::Otros:
                    begin
                        case lrFiltroTipo."Valor Id" of
                            1:
                                begin // Cód. Grupo Producto
                                    Clear(lrCodGrProd);
                                    //CopyFilter("Filtro Tipologia", lrCodGrProd."Item Category Code");
                                    rec.CopyFilter("Filtro Tipologia", lrCodGrProd.Code);
                                    if lrCodGrProd.FindSet then begin
                                        repeat
                                            AddReg(pwIdFiltro, lrCodGrProd.Code, lrCodGrProd.Description);
                                        until lrCodGrProd.Next = 0;
                                    end;
                                end;
                        end;
                    end;
            end;
        end;
    end;


    procedure AddReg(pwIdFiltro: Integer; pwCode: Text; pwDescrpt: Text)
    begin
        // AddReg

        rec.Init;
        wId += 1;
        rec.Id := wId;
        rec."Id Filtro" := pwIdFiltro;
        rec.Code := pwCode;
        rec.Description := pwDescrpt;
        rec.Insert;
    end;
}

