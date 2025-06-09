/* tableextension 50001 tableextension50001 extends "Bank Rec. Line"
{
    fields
    {
        modify(Description)
        {
            Description = '#56924';
        }
        modify("Bank Ledger Entry No.")
        {
            Caption = 'Bank Ledger Entry No.';
        }
        modify("Check Ledger Entry No.")
        {
            Caption = 'Check Ledger Entry No.';
        }
        modify("Adj. Source Record ID")
        {
            Caption = 'Adj. Source Record ID';
        }
        modify("Adj. Source Document No.")
        {
            Caption = 'Adj. Source Document No.';
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        modify("Shortcut Dimension 2 Code")
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(55005; "RUC/Cedula"; Code[30])
        {
            Caption = 'Vat Reg. Number';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin

                //004
                TestField("Tipo de Comprobante");
                SRIParam.Reset;
                SRIParam.Get(1, "Tipo de Comprobante");
                if not SRIParam."No Aplica SRI" then
                    //FuncEcuador.ValidaDigitosRUC("RUC/Cedula",1);
                    FuncEcuador.ValidaDigitosRUCCajaChica("RUC/Cedula");
                //004
            end;
        }
        field(55006; "Tipo de Comprobante"; Code[2])
        {
            Caption = 'NCF Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            begin
                Clear("RUC/Cedula");//004
            end;
        }
        field(55007; "Sustento del Comprobante"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            TableRelation = "SRI - Tabla Parametros".Code WHERE ("Tipo Registro" = FILTER ("SUSTENTO DEL COMPROBANTE"));
        }
        field(55008; "No. Autorizacion Comprobante"; Code[37])
        {
            Caption = 'Authorization Voucher No.';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                //004
                if StrLen("No. Autorizacion Comprobante") <> 10 then
                    Error(Error002, FieldCaption("No. Autorizacion Comprobante"));
                //004
            end;
        }
        field(55009; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                if StrLen(Establecimiento) <> 3 then
                    Error(Error003, FieldCaption(Establecimiento));
            end;
        }
        field(55010; "Punto de Emision"; Code[3])
        {
            Caption = 'Issue date';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';

            trigger OnValidate()
            begin
                if StrLen("Punto de Emision") <> 3 then
                    Error(Error003, FieldCaption("Punto de Emision"));
            end;
        }
        field(55011; "Fecha Caducidad"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
    }

    var
        "***Santillana***": Integer;
        VATRegNoFormat: Record "VAT Registration No. Format";
        FuncEcuador: Codeunit "Funciones Ecuador";
        SRIParam: Record "SRI - Tabla Parametros";
        UserSetUp: Record "User Setup";
        Error002: Label 'the leng of the field %1 must be of 10 digits';
        Error003: Label 'La longitud del campo %1 debe ser de 3 dígitos';
}

 */