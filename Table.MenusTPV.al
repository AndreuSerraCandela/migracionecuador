table 76027 "Menus TPV"
{
    Caption = 'POS Menus';

    fields
    {
        field(76046; "Menu ID"; Code[10])
        {
            Caption = 'ID Menu';
            Description = 'DsPOS Standar';
            NotBlank = true;
        }
        field(76029; Descripcion; Text[250])
        {
            Caption = 'Description';
            Description = 'DsPOS Standar';
        }
        field(76011; "Cantidad de botones"; Integer)
        {
            CalcFormula = Count (Botones WHERE ("ID Menu" = FIELD ("Menu ID"),
                                               Activo = CONST (true)));
            Caption = 'Quantity of buttons';
            Description = 'DsPOS Standar';
            FieldClass = FlowField;
        }
        field(340025003; "Tipo Menu"; Option)
        {
            Description = 'DsPOS Standar';
            OptionMembers = ,Acciones,Pagos,Productos;

            trigger OnValidate()
            var
                rBotones: Record Botones;
            begin
                TestField("Menu ID");

                if "Tipo Menu" <> xRec."Tipo Menu" then begin
                    rBotones.Reset;
                    rBotones.SetRange(rBotones."ID Menu", "Menu ID");
                    if rBotones.FindFirst then
                        Error(Error004);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Menu ID")
        {
            Clustered = true;
        }
        key(Key2; "Tipo Menu")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Menu ID", Descripcion)
        {
        }
    }

    trigger OnDelete()
    var
        rBot: Record Botones;
        rConfTPV: Record "Configuracion TPV";
    begin

        rConfTPV.SetCurrentKey("Menu de acciones", "Menu de Formas de Pago", "Menu de productos");
        case "Tipo Menu" of
            "Tipo Menu"::Acciones:
                rConfTPV.SetRange("Menu de acciones", "Menu ID");
            "Tipo Menu"::Pagos:
                rConfTPV.SetRange("Menu de Formas de Pago", "Menu ID");
            "Tipo Menu"::Productos:
                rConfTPV.SetRange("Menu de productos", "Menu ID");
        end;

        if rConfTPV.FindSet then begin
            if not Confirm(Text001, false) then
                Error(Error003);
            case "Tipo Menu" of
                "Tipo Menu"::Acciones:
                    rConfTPV.ModifyAll("Menu de acciones", '');
                "Tipo Menu"::Pagos:
                    rConfTPV.ModifyAll("Menu de Formas de Pago", '');
                "Tipo Menu"::Productos:
                    rConfTPV.ModifyAll("Menu de productos", '');
            end;
        end;

        rBot.SetRange("ID Menu", "Menu ID");
        if rBot.FindSet then
            rBot.DeleteAll(false);
    end;

    trigger OnInsert()
    var
        rAcciones: Record Acciones;
        rBotones: Record Botones;
    begin

        TestField(Descripcion);
        TestField("Tipo Menu");

        if "Tipo Menu" = "Tipo Menu"::Acciones then begin
            rAcciones.SetCurrentKey("Tipo Accion");
            rAcciones.SetRange("Tipo Accion", rAcciones."Tipo Accion"::Obligatoria);
            if rAcciones.FindSet then
                repeat
                    rBotones.Init;
                    rBotones."ID Menu" := "Menu ID";
                    rBotones.Descripcion := rAcciones.Descripcion;
                    rBotones.Accion := rAcciones."ID Accion";
                    rBotones."Tipo Accion" := rAcciones."Tipo Accion" + 1;
                    rBotones.Etiqueta := UpperCase(rBotones.Descripcion);
                    rBotones.Activo := true;
                    rBotones.Insert(true);
                until rAcciones.Next = 0;
        end;
    end;

    trigger OnModify()
    var
        rBotones: Record Botones;
    begin
    end;

    var
        Error001: Label 'Error de Configuración. El Menú esta configurado como acciones para Tienda %1 TPV %2';
        Error002: Label 'Error de Configuración. El Menú esta configurado como Menu de Pagos para Tienda %1 TPV %2';
        Error003: Label 'Proceso Cancelado a Petición del Usuario';
        Error004: Label 'Imposible Cambiar el Tipo de Menú por tener ya registros configurados, primero debe borrarlos';
        Text001: Label 'El Menu que intenta BORRAR esta asignado a uno o mas TPV''s , ¿Desasignar automáticamente?';
}

