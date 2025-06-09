#pragma implicitwith disable
page 75013 "Filtro Campo"
{
    ApplicationArea = all;
    // YA SE que codigo en la page no es lo suyo
    // El problema es que NO puede estar en la tabla ya que se trata como una tabla "Temporal" todo el tiempo y no cosume licencia
    // Si introducimos código dentro de la tabla, El sistema Si solicitará licencia para este objeto.

    Editable = false;
    PageType = ConfirmationDialog;
    SourceTable = "Filtro Campo Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Id"; rec."Table Id")
                {
                }
                field("Field No"; rec."Field No")
                {
                }
                field(Name; rec.Name)
                {
                }
                field(Caption; rec.Caption)
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
        RellenaTemp(Rec.GetRangeMin("Table Id"))
    end;

    var
        cFunMdm: Codeunit "Funciones MdM";


    procedure RellenaTemp(pwTableId: Integer)
    var
        lrFields: Record "Field";
        lwId: Integer;
        lwIDFld: Integer;
        lwName: Text;
    begin
        // RellenaTemp

        // Recuerde que la tabla en cuestión debe de ser temporal
        Clear(Rec);
        Rec.DeleteAll;

        if pwTableId = 0 then
            exit;

        Clear(lrFields);
        lrFields.SetRange(TableNo, pwTableId);
        if lrFields.FindSet then begin
            repeat
                InsertaReg(lrFields.TableNo, lrFields."No.", lrFields.FieldName, lrFields."Field Caption");
            until lrFields.Next = 0;
        end;

        case pwTableId of
            27:
                begin // Producto
                      // Añadimos las dimensiones como campos virtuales
                    for lwId := 0 to cFunMdm.GetTotalGestDim - 1 do begin
                        lwIDFld := -(200 + lwId);
                        lwName := cFunMdm.GetDimNameField(lwId);
                        InsertaReg(27, lwIDFld, lwName, lwName);
                    end;
                end;
        end;
    end;


    procedure TestCampo(pwIdTable: Integer; pwIdField: Integer)
    var
        lrFields: Record "Field";
        lwIdDim: Integer;
    begin
        // TestCampo
        if (pwIdTable = 0) or (pwIdField = 0) then
            exit;

        lrFields.Get(pwIdTable, pwIdField);

        if (pwIdTable = 27) and (pwIdField < 0) then begin // Campos Virtuales
            case pwIdField of
                -299 .. -200:
                    begin // Dimensiones
                        lwIdDim := -(pwIdField + 200);
                        cFunMdm.GetDimCode(lwIdDim, true);
                    end;
            end;
        end
        else
            lrFields.Get(pwIdTable, pwIdField);
    end;


    procedure InsertaReg(pwTableId: Integer; pwFieldNo: Integer; pwName: Text; pwCaption: Text)
    begin
        // InsertaReg

        Rec.Init;
        Rec."Table Id" := pwTableId;
        Rec."Field No" := pwFieldNo;
        Rec.Name := pwName;
        Rec.Caption := pwCaption;
        Rec.Insert;
    end;
}

#pragma implicitwith restore

