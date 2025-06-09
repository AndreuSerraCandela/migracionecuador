table 76017 Botones
{
    Caption = 'Buttons';

    fields
    {
        field(76046; "ID Menu"; Code[10])
        {
            Caption = 'Menu ID';
            Description = 'DsPOS Standar';
            Editable = false;
        }
        field(76029; "ID boton"; Integer)
        {
            Caption = 'Boton ID';
            Description = 'DsPOS Standar';
            NotBlank = true;
        }
        field(76011; Descripcion; Text[250])
        {
            Caption = 'Description';
            Description = 'DsPOS Standar';
        }
        field(76016; Accion; Code[20])
        {
            Caption = 'Action';
            Description = 'DsPOS Standar';
            TableRelation = Acciones."ID Accion" WHERE("Tipo Accion" = FILTER(<> Obligatoria));

            trigger OnValidate()
            var
                rMenu: Record "Menus TPV";
                rBotones: Record Botones;
                rAccion: Record Acciones;
            begin

                if (Accion = '') and not (Activo) then begin
                    "Tipo Accion" := 0;
                    exit;
                end;

                rMenu.Get("ID Menu");
                rMenu.TestField("Tipo Menu", rMenu."Tipo Menu"::Acciones);

                rBotones.SetRange("ID Menu", "ID Menu");
                rBotones.SetFilter("ID boton", '<>%1', "ID boton");
                rBotones.SetFilter(Accion, '%1', Accion);
                if rBotones.FindFirst then
                    if (StrPos(Accion, 'DTO') = 0) then
                        Error(Error003, Accion);

                rAccion.Get(Accion);
                Descripcion := rAccion.Descripcion;
                "Tipo Accion" := rAccion."Tipo Accion" + 1;
                Etiqueta := UpperCase(Descripcion);
            end;
        }
        field(76018; Etiqueta; Text[30])
        {
            Caption = 'Caption';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            begin
                Etiqueta := UpperCase(Etiqueta);
            end;
        }
        field(76015; Color; Integer)
        {
            Description = 'DsPOS Standar';
        }
        field(76026; Activo; Boolean)
        {
            Caption = 'Active';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                rMenu: Record "Menus TPV";
            begin
                if not Activo then
                    exit;

                rMenu.Get("ID Menu");
                case true of
                    rMenu."Tipo Menu" = rMenu."Tipo Menu"::Acciones:
                        TestField(Accion);
                    rMenu."Tipo Menu" = rMenu."Tipo Menu"::Pagos:
                        TestField(Pago);
                end;

                ComprobarOrden;

                rMenu.Reset;
                rMenu.Get("ID Menu");
                case rMenu."Tipo Menu" of
                    rMenu."Tipo Menu"::Acciones:
                        begin
                            TestField(Pago, '');
                            TestField(Etiqueta);
                            TestField(Descripcion);
                            TestField(Accion);
                            if (StrPos(Accion, 'DTO') <> 0) and ("Descuento %" = 0) then
                                if not Confirm(Text001, false) then
                                    Error(Error013);
                        end;
                    rMenu."Tipo Menu"::Pagos:
                        begin
                            TestField(Pago);
                            TestField(Descripcion);
                            TestField(Etiqueta);
                            TestField(Tipo, 0);
                            TestField("No.", '');
                            TestField("Descuento %", 0);
                            TestField(Accion, '');
                        end;
                end;
            end;
        }
        field(76020; "Descuento %"; Decimal)
        {
            Caption = 'Discount %';
            Description = 'DsPOS Standar';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Descuento %" = 0 then
                    exit;
            end;
        }
        field(76022; Seguridad; Option)
        {
            Caption = 'Password';
            Description = 'DsPOS Standar';
            OptionCaption = ' ,Password';
            OptionMembers = " ","Contraseña";

            trigger OnValidate()
            begin
                TestField(Accion);
                TestField("Tipo Accion");
            end;
        }
        field(76027; Pago; Code[20])
        {
            Caption = 'Tender';
            Description = 'DsPOS Standar';
            TableRelation = "Formas de Pago" WHERE("Tipo Tarjeta" = FILTER(''),
                                                    "Efectivo Local" = CONST(false));

            trigger OnValidate()
            var
                rMenu: Record "Menus TPV";
                rFormPago: Record "Formas de Pago";
                rBotones: Record Botones;
            begin
                if Pago = '' then
                    exit;

                rMenu.Reset;
                rMenu.Get("ID Menu");
                rMenu.TestField("Tipo Menu", rMenu."Tipo Menu"::Pagos);

                rFormPago.Reset;
                rFormPago.Get(Pago);
                if (rFormPago."Efectivo Local") or (rFormPago."Tipo Tarjeta" <> '') then
                    Error(Error001);

                rBotones.SetRange("ID Menu", "ID Menu");
                rBotones.SetFilter("ID boton", '<>%1', "ID boton");
                rBotones.SetFilter(Pago, '%1', Pago);
                if rBotones.FindFirst then
                    Error(Error002, Pago);

                Descripcion := rFormPago.Descripcion;
            end;
        }
        field(76025; Tipo; Option)
        {
            Description = 'DsPOS Standar';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset";

            trigger OnValidate()
            begin

                if (Tipo <> xRec.Tipo) and
                  ("No." <> '') then
                    "No." := '';
            end;
        }
        field(76017; "No."; Code[20])
        {
            Description = 'DsPOS Standar';
            TableRelation = IF (Tipo = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Tipo = CONST(Item)) Item
            ELSE
            IF (Tipo = CONST(Resource)) Resource
            ELSE
            IF (Tipo = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(76030; "Tipo Accion"; Option)
        {
            Description = 'DsPOS Standar';
            Editable = false;
            OptionCaption = ',Action,Mandatory,Line Action';
            OptionMembers = ,"Acción",Obligatoria,"Acción Línea";
        }
        field(76227; Orden; Integer)
        {
            Description = 'DsPOS Standar';

            trigger OnValidate()
            begin

                if Orden < 0 then
                    Error(Error007);

                ComprobarOrden;
            end;
        }
    }

    keys
    {
        key(Key1; "ID Menu", "ID boton")
        {
            Clustered = true;
        }
        key(Key2; Pago)
        {
        }
        key(Key3; "Tipo Accion", Orden)
        {
        }
        key(Key4; Accion)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        case true of
            Activo:
                Error(Error010);
            "Tipo Accion" = "Tipo Accion"::Obligatoria:
                Error(Error011);
        end;
    end;

    trigger OnInsert()
    var
        rBotones: Record Botones;
    begin

        rBotones.Reset;
        rBotones.SetRange("ID Menu", "ID Menu");
        if rBotones.FindLast then
            "ID boton" := rBotones."ID boton" + 1
        else
            "ID boton" := 1;

        if "Tipo Accion" <> "Tipo Accion"::Obligatoria then begin
            rBotones.Reset;
            rBotones.SetCurrentKey("Tipo Accion", Orden);
            rBotones.SetRange("Tipo Accion", "Tipo Accion");
            if rBotones.FindLast then
                Orden := rBotones.Orden + 1
            else
                Orden := 1;
        end;
    end;

    trigger OnModify()
    begin

        case true of
            (xRec.Activo) and not (Activo):
                exit;
            Activo and not (xRec.Activo):
                exit;
            Activo and xRec.Activo:
                Error(Error009);
            (("Tipo Accion" = "Tipo Accion"::Obligatoria) and
          ((Etiqueta = xRec.Etiqueta) and (Seguridad = xRec.Seguridad))):
                Error(Error012);
        end;
    end;

    var
        Error001: Label 'Las Formas de Pago Efectivo Local y Tarjetas se añaden automáticamente';
        Error002: Label 'El pago %1 ya existe en otro botón del menú';
        Error003: Label 'La Accion %1 ya existe en otro botón del menú';
        Error004: Label 'El Orden %1 ya existe en otro botón activo del menú';
        Error005: Label 'No puede Asignar orden 0 a un botón Activo';
        Error007: Label 'Orden Debe ser Positivo';
        Error008: Label 'NO se debe configurar orden cuanto Tipo Accion es Obligatoria';
        Error009: Label 'Imposible Modificar un registro Activo';
        Error010: Label 'Imposible Borrar un Botón Activo';
        Error011: Label 'Imposible Borrar una acción Obligatoria';
        Error012: Label 'Cuando Tipo Acción es obligatoria sólo se permite cambiar Etiqueta y Seguridad';
        Error013: Label 'Proceso Cancelado a Petición del usuario';
        Text001: Label 'No ha especifacado un % de descuento, el usuario tendrá libertad de especificar el mismo\¿Aún desea activar el botón?';


    procedure ComprobarOrden()
    var
        rBotones: Record Botones;
    begin

        case true of
            ((Orden = 0) and ("Tipo Accion" = "Tipo Accion"::Obligatoria)):
                exit;
            (Orden <> 0) and ("Tipo Accion" = "Tipo Accion"::Obligatoria):
                Error(Error008);
            ((Orden = 0) and Activo) and not ("Tipo Accion" = "Tipo Accion"::Obligatoria):
                Error(Error005);
        end;

        rBotones.Reset;
        rBotones.SetRange("ID Menu", "ID Menu");
        rBotones.SetRange(Orden, Orden);
        rBotones.SetFilter("ID boton", '<>%1', "ID boton");
        rBotones.SetRange(Activo, true);
        rBotones.SetRange("Tipo Accion", "Tipo Accion");
        if rBotones.FindFirst then
            Error(Error004, Orden);
    end;
}

