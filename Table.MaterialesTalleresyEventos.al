table 76322 "Materiales Talleres y Eventos"
{

    fields
    {
        field(1; "Cod. Taller - Evento"; Code[20])
        {
            NotBlank = true;
            TableRelation = Eventos."No.";

            trigger OnValidate()
            begin
                if Evento.Get("Cod. Taller - Evento") then
                    "Description Taller" := Evento.Descripcion;
            end;
        }
        field(2; "Tipo Evento"; Code[20])
        {
            Editable = false;
            TableRelation = "Tipos de Eventos";
        }
        field(3; "Line no."; Integer)
        {
        }
        field(4; "Tipo de Material"; Option)
        {
            OptionCaption = 'Item,Other';
            OptionMembers = Producto,Otro;
        }
        field(5; "Codigo Material"; Code[20])
        {
            NotBlank = true;
            TableRelation = IF ("Tipo de Material" = CONST (Otro)) "Datos auxiliares".Codigo WHERE ("Tipo registro" = CONST (Materiales))
            ELSE
            IF ("Tipo de Material" = CONST (Producto)) Item;

            trigger OnValidate()
            begin
                case "Tipo de Material" of
                    0:
                        begin
                            Item.Get("Codigo Material");
                            "Description Material" := Item.Description;
                            "Costo Unitario" := Item."Unit Cost";
                        end;
                    1:
                        begin
                            if "Codigo Material" <> '' then begin
                                DA.Reset;
                                DA.SetRange("Tipo registro", DA."Tipo registro"::Materiales);
                                DA.SetRange(Codigo, "Codigo Material");
                                DA.FindFirst;
                                "Description Material" := DA.Descripcion;
                                "Costo Unitario" := DA."Costo Unitario";
                            end;
                        end;
                end;
            end;
        }
        field(6; "Description Taller"; Text[100])
        {
            Editable = false;
        }
        field(7; "Description Material"; Text[100])
        {
            Editable = false;
        }
        field(8; Cantidad; Integer)
        {
        }
        field(9; "Costo Unitario"; Decimal)
        {
        }
        field(10; Secuencia; Integer)
        {
        }
        field(11; Expositor; Code[20])
        {
            TableRelation = IF ("Tipo de Expositor" = CONST (Docente)) Docentes WHERE (Expositor = CONST (true))
            ELSE
            IF ("Tipo de Expositor" = CONST (Proveedor)) Vendor;
        }
        field(12; "Tipo de Expositor"; Option)
        {
            OptionCaption = 'Teacher,Vendor';
            OptionMembers = Docente,Proveedor;
        }
    }

    keys
    {
        key(Key1; "Cod. Taller - Evento", "Tipo Evento", Expositor, Secuencia, "Line no.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Evento: Record Eventos;
        DA: Record "Datos auxiliares";
        Item: Record Item;
}

