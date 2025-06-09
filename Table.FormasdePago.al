table 76030 "Formas de Pago"
{
    // #78451  12/07/2017  PLB: Añadido campo "Forma pago" para seleccionar la forma de pago de Dynamics NAV a cada forma de pago del POS
    // #116527 07/11/2018  RRT: Adaptaciones para unificación de los objetos en todos los paises
    // #70132  03.07.2018  RRT: Creación del campo "Tipo compensación NC" para determinar si es una forma de pago que relaciona una NC como medio de pago.
    // #232158 11.06.2019  RRT: Las mismas validaciones que para Honduras son buenas para guatemala.

    Caption = 'Tender Types POS';
    DrillDownPageID = "Lista Formas de Pago";
    LookupPageID = "Lista Formas de Pago";

    fields
    {
        field(76046; "ID Pago"; Code[20])
        {
            Caption = 'Payment ID';
            Description = 'DsPOS Standar';
            NotBlank = true;
        }
        field(76029; Descripcion; Text[250])
        {
            Caption = 'Description';
            Description = 'DsPOS Standar';
        }
        field(76016; "Efectivo Local"; Boolean)
        {
            Caption = 'Cash in Local Currency';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                rFormPago: Record "Formas de Pago";
            begin
                if not "Efectivo Local" then
                    exit;

                rFormPago.Reset;
                rFormPago.SetCurrentKey("Efectivo Local", "Cod. divisa");
                rFormPago.SetRange("Efectivo Local", true);
                rFormPago.SetFilter("ID Pago", '<>%1', "ID Pago");
                if rFormPago.FindFirst then
                    Error(error001);

                TestField("Cod. divisa", '');
                TestField("Tipo Tarjeta", '');

                "Abre cajon" := true;
                "Realizar recuento" := true;
            end;
        }
        field(76018; "Cod. divisa"; Code[10])
        {
            Caption = 'Currency code';
            Description = 'DsPOS Standar';
            TableRelation = Currency;

            trigger OnValidate()
            var
                rFormPago: Record "Formas de Pago";
                lrConf: Record "Configuracion General DsPOS";
            begin

                if "Cod. divisa" = '' then
                    exit;

                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error004);
                //-#116527 / #232158

                TestField("Efectivo Local", false);
                TestField("Tipo Tarjeta", '');

                rFormPago.Reset;
                rFormPago.SetCurrentKey("Efectivo Local", "Cod. divisa");
                rFormPago.SetFilter("ID Pago", '<>%1', "ID Pago");
                rFormPago.SetFilter("Cod. divisa", '%1', "Cod. divisa");
                if rFormPago.FindFirst then
                    Error(error002, "Cod. divisa");

                "Realizar recuento" := true;
            end;
        }
        field(76026; "Abre cajon"; Boolean)
        {
            Caption = 'Open Drawer';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            begin
                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error005);
                //-#116527 / #232158
            end;
        }
        field(76025; "Tipo Tarjeta"; Code[10])
        {
            Description = 'DsPOS Standar';
            TableRelation = "Tipos de Tarjeta".Codigo;

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            begin
                if "Tipo Tarjeta" = '' then
                    exit;

                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error005);
                //-#116527 / #232158

                TestField("Efectivo Local", false);
                TestField("Cod. divisa", '');
                TestField("Realizar recuento", false);
            end;
        }
        field(76017; "Realizar recuento"; Boolean)
        {
            Caption = 'Realizar recuento';
            Description = 'DsPOS Standar';

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            begin
                TestField("Tipo Tarjeta", '');

                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error005);
                //-#116527 / #232158
            end;
        }
        field(76021; Icono; BLOB)
        {
            Caption = 'Icon';
            Compressed = false;
            Description = 'DsPOS Standar';
            SubType = Bitmap;

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            begin
                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error005);
                //-#116527 / #232158
            end;
        }
        field(76030; "Icono Nav"; BLOB)
        {
            Description = 'DsPOS Standar';
            SubType = Bitmap;

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            begin
                //+#116527 / #232158
                if lrConf.FindFirst then
                    if (lrConf.Pais = lrConf.Pais::Honduras) or (lrConf.Pais = lrConf.Pais::Guatemala) then
                        if "ID Pago" = 'EXIVA' then
                            Error(Error005);
                //-#116527 / #232158
            end;
        }
        field(76295; "Forma pago"; Code[10])
        {
            Description = '#78451';
            TableRelation = "Payment Method";
        }
        field(76227; "Tipo Compensacion NC"; Option)
        {
            Description = '#70132';
            OptionMembers = No,"Sí";
        }
    }

    keys
    {
        key(Key1; "ID Pago")
        {
            Clustered = true;
        }
        key(Key2; "Efectivo Local", "Cod. divisa")
        {
        }
        key(Key3; "Tipo Tarjeta")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "ID Pago", Descripcion)
        {
        }
    }

    trigger OnDelete()
    var
        rBotones: Record Botones;
    begin

        rBotones.Reset;
        rBotones.SetCurrentKey(Pago);
        rBotones.SetRange(Pago, "ID Pago");
        if rBotones.FindFirst then
            if rBotones.Activo then
                Error(error003, rBotones."ID Menu");
    end;

    var
        error001: Label 'Already exist a Change tender type';
        error002: Label 'Ya existe una forma de pago para divisa %1';
        error003: Label 'IMPOSIBLE BORRAR La forma de pago esta asginada al Menu Pagos %1';
        Error004: Label 'No puede especificar Código Divisa para Exención de IVA';
        Error005: Label 'Exención de IVA no es configurable';
}

