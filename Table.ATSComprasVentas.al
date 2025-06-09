table 55007 "ATS Compras/Ventas"
{
    // #34829  13/11/2015  CAT Se modifica campo "Pago proveedor local o ext" a "Pago a residente"
    // #43088  26/01/2016  CAT Se modifican los campos Reg. Fiscal preferente/Paraiso, Tiene Convenio y Sujeto a Retencion
    // #45384  19/02/2016  MOI Se amplia el campo No. Autorizacion Documento de 37 a 49 para igualarlo con el tamaño del campo No Autorizacion Documento de la tabla Sales Invoice Header.

    Caption = 'ATS Compras/Ventas';

    fields
    {
        field(1; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Cotización,Pedido,Factura,Crédito,Pedido abierto,Devolución,Retencion';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Retencion;
        }
        field(2; "No. Documento"; Code[30])
        {
        }
        field(3; Descripcion; Text[100])
        {
        }
        field(4; "Fecha Registro"; Date)
        {
        }
        field(5; "Numero Comprobante Fiscal"; Code[30])
        {
        }
        field(6; Importe; Decimal)
        {
        }
        field(7; "Importe IVA"; Decimal)
        {
        }
        field(8; "Importe IVA Incl."; Decimal)
        {
        }
        field(9; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset,Employee';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset",Employee;
        }
        field(10; "Source No."; Code[30])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST (Customer)) Customer
            ELSE
            IF ("Source Type" = CONST (Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST ("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST ("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST (Employee)) Employee;
        }
        field(11; "RUC/Cedula"; Code[30])
        {
        }
        field(12; "Cod. Retencion 1"; Code[30])
        {
            Caption = 'Cód. Retención 1';
        }
        field(13; "Importe Retencion 1"; Decimal)
        {
            Caption = 'Importe Retención 1';
        }
        field(14; "Cod. Retencion 2"; Code[30])
        {
            Caption = 'Cód. Retención 2';
        }
        field(15; "Importe Retencion 2"; Decimal)
        {
            Caption = 'Importe Retención 2';
        }
        field(16; "Cod. Retencion 3"; Code[30])
        {
            Caption = 'Cód. Retención 3';
        }
        field(17; "Importe Retencion 3"; Decimal)
        {
            Caption = 'Importe Retención 3';
        }
        field(18; "No. Autorizacion Documento"; Code[49])
        {
            Description = '#45384';
        }
        field(19; "Punto Emision Documento"; Code[3])
        {
        }
        field(20; "Establecimiento Documento"; Code[3])
        {
        }
        field(21; "No. Pedido"; Code[20])
        {
            Caption = 'Order No.';
        }
        field(22; "Comprobante Egreso"; Code[30])
        {
            Description = 'No. Documento Pago (Diario de Pago)';
        }
        field(23; "12% IVA"; Decimal)
        {
        }
        field(24; "Tipo Retencion"; Code[20])
        {
        }
        field(25; "Fecha Caducidad"; Date)
        {
        }
        field(26; "% Retencion"; Decimal)
        {
        }
        field(27; "Retencion IVA"; Boolean)
        {
        }
        field(28; "Tipo Comprobante"; Code[2])
        {
        }
        field(29; "Importe Base Retencion"; Decimal)
        {
        }
        field(30; "Secuencia Contabilidad"; Integer)
        {
        }
        field(31; "Base Retencion 1"; Decimal)
        {
        }
        field(32; "Base Retencion 2"; Decimal)
        {
        }
        field(33; "Base Retencion 3"; Decimal)
        {
        }
        field(34; "Porcentaje Retencion 1"; Decimal)
        {
        }
        field(35; "Porcentaje Retencion 2"; Decimal)
        {
        }
        field(36; "Porcentaje Retencion 3"; Decimal)
        {
        }
        field(37; _EXENTO; Decimal)
        {
        }
        field(38; _GR_0; Decimal)
        {
        }
        field(39; _GR_12; Decimal)
        {
        }
        field(40; "10_SERVIC"; Decimal)
        {
        }
        field(41; Tipo; Option)
        {
            OptionMembers = Compra,Venta;
        }
        field(42; "No. Comprobante Retencion 1"; Code[30])
        {
        }
        field(43; "No. Autorizacion Retencion 1"; Code[49])
        {
        }
        field(44; "Punto Emision Retencion 1"; Code[3])
        {
        }
        field(45; "Establecimiento Retencion 1"; Code[3])
        {
        }
        field(46; "Fecha Caducidad Retencion 1"; Date)
        {
        }
        field(47; "No. Comprobante Retencion 2"; Code[30])
        {
        }
        field(48; "No. Autorizacion Retencion 2"; Code[49])
        {
            Description = 'WI 118543';
        }
        field(49; "Punto Emision Retencion 2"; Code[3])
        {
        }
        field(50; "Establecimiento Retencion 2"; Code[3])
        {
        }
        field(51; "Fecha Caducidad Retencion 2"; Date)
        {
        }
        field(52; "No. Comprobante Retencion 3"; Code[30])
        {
        }
        field(53; "No. Autorizacion Retencion 3"; Code[49])
        {
            Description = 'WI 118543';
        }
        field(54; "Punto Emision Retencion 3"; Code[3])
        {
        }
        field(55; "Establecimiento Retencion 3"; Code[3])
        {
        }
        field(56; "Fecha Caducidad Retencion 3"; Date)
        {
        }
        field(57; "Sustento del Comprobante"; Code[10])
        {
            Caption = 'Voucher Sustentation';
            Description = 'SRI';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("SUSTENTO DEL COMPROBANTE"));

            trigger OnValidate()
            begin
                if SRI.Get(0, "Sustento del Comprobante") then
                    "Desc. Sustento Comprobante" := CopyStr(SRI.Description, 1, 50)
                else
                    Clear("Desc. Sustento Comprobante");
            end;
        }
        field(58; "Desc. Sustento Comprobante"; Text[150])
        {
        }
        field(59; "Parte Relacionada"; Boolean)
        {
            Description = '#14564 Ecuador';
        }
        field(60; "Tipo Contribuyente"; Code[20])
        {
            Caption = 'Contributor Type';
            Description = '#14564 Ecuador';
            TableRelation = Vendor;
        }
        field(61; "Forma de Pago"; Code[2])
        {
            Description = '#14564 Ecuador';
        }
        field(62; "Fecha Emision Retencion"; Date)
        {
            Description = '#14564 Ecuador';
        }
        field(63; "Pago a residente"; Code[2])
        {
            Description = '#14564 Ecuador,#34829';
        }
        field(64; "Codigo de Pais"; Code[4])
        {
            Description = '#14564 Ecuador';
        }
        field(65; "Tiene Convenio"; Option)
        {
            Description = '#14564 Ecuador,#43088';
            OptionCaption = ' ,Sí,No';
            OptionMembers = " ","Sí",No;
        }
        field(66; "Sujeto a Retencion"; Option)
        {
            Description = '#14564 Ecuador,#43088';
            OptionCaption = ' ,Sí,No';
            OptionMembers = " ","Sí",No;
        }
        field(67; Exportacion; Boolean)
        {
            Description = '#14564 Ecuador';
        }
        field(70; "Base 0%"; Decimal)
        {
            Caption = 'Base 0%';
            Description = '#14564 Ecuador';
        }
        field(80; "Base 12%"; Decimal)
        {
            Caption = 'Base 12%';
            Description = '#14564 Ecuador';
        }
        field(81; "Tipo de Identificador"; Code[10])
        {
            Description = '#16511';

            trigger OnValidate()
            begin
                case "Tipo de Identificador" of
                    'R':
                        "Cod. Tipo Indentificador" := '01';
                    'P':
                        "Cod. Tipo Indentificador" := '03';
                    'C':
                        "Cod. Tipo Indentificador" := '02';
                end;
            end;
        }
        field(82; "Fecha Emicion Doc"; Date)
        {
            Description = '#16511 Ecuador';
        }
        field(83; "No. Comprobante Fiscal Rel."; Code[30])
        {
            Description = '#16511';
        }
        field(84; "No.Autorizacion Factura Rel."; Code[49])
        {
            Description = 'ATS';
        }
        field(85; "Punto Emision Factura Rel."; Code[3])
        {
            Description = 'ATS';
        }
        field(86; "Establecimiento Factura Rel."; Code[3])
        {
            Description = 'ATS';
        }
        field(87; "Tipo Comprobante Factura Rel."; Code[2])
        {
            Description = 'ATS';
        }
        field(88; "Con Refrendo"; Boolean)
        {
            Description = 'ATS';
        }
        field(89; "Nº Refrendo"; Text[17])
        {
            Description = 'ATS';
        }
        field(90; "Nº Documento Transporte"; Text[17])
        {
            Description = 'ATS';
        }
        field(91; "Fecha embarque"; Date)
        {
            Description = 'ATS';
        }
        field(92; "Cod. Tipo Indentificador"; Code[2])
        {
            Description = 'ATS';
        }
        field(93; "Mes - Periodo"; Integer)
        {
        }
        field(94; "Año - Periodo"; Integer)
        {
        }
        field(95; "Nombre Proveedor"; Text[160])
        {
        }
        field(96; "Reg. Fiscal preferente/Paraiso"; Option)
        {
            Description = '#43088';
            OptionCaption = ' ,Sí,No';
            OptionMembers = " ","Sí",No;
        }
        field(97; "Caja Chica"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Tipo Documento", "No. Documento", "Cod. Retencion 1", "Tipo Retencion")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        SRI: Record "SRI - Tabla Parametros";
}

