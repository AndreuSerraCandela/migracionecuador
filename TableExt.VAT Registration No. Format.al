tableextension 50072 tableextension50072 extends "VAT Registration No. Format"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Format(Field 3)".

        field(55002; "Tipo Ruc/Cedula"; Option)
        {
            Caption = 'RUC/ID Type';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
            OptionCaption = ' ,R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA,R.U.C. PUBLICOS,RUC PERSONA NATURAL,ID';
            OptionMembers = " ","R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA","R.U.C. PUBLICOS","RUC PERSONA NATURAL",CEDULA;
        }
    }

    local procedure CheckCust(VATRegNo: Text[20]; Number: Code[20])
    var
        IsHandled: Boolean;
        Check: Boolean;
        TextString: Text[250];
        Finish: Boolean;
        CustomerIdentification: Text[250];
        Cust: Record Customer;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        Check := true;
        TextString := '';
        Cust.SetCurrentKey("VAT Registration No.");
        Cust.SetRange("VAT Registration No.", VATRegNo);
        Cust.SetFilter("No.", '<>%1', Number);
        if Cust.FindSet then begin
            Check := false;
            Finish := false;
            repeat

                CustomerIdentification := Cust.Name;
                AppendString(TextString, Finish, CustomerIdentification);
            until (Cust.Next = 0) or Finish;
        end;
        if not Check then
            Message(StrSubstNo(Text002, TextString));
    end;

    local procedure CheckVendor(VATRegNo: Text[20]; Number: Code[20])
    var
        IsHandled: Boolean;
        Check: Boolean;
        TextString: Text[250];
        Finish: Boolean;
        Vend: Record Vendor;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        Check := true;
        TextString := '';
        Vend.SetCurrentKey("VAT Registration No.");
        Vend.SetRange("VAT Registration No.", VATRegNo);
        Vend.SetFilter("No.", '<>%1', Number);
        if Vend.FindSet then begin
            Check := false;
            Finish := false;
            repeat
                AppendString(TextString, Finish, Vend."No.");
            until (Vend.Next = 0) or Finish;
        end;
        if not Check then
            Message(StrSubstNo(Text003, TextString));
    end;

    local procedure CheckContact(VATRegNo: Text[20]; Number: Code[20])
    var
        IsHandled: Boolean;
        Check: Boolean;
        TextString: Text[250];
        Finish: Boolean;
        Cont: Record Contact;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        Check := true;
        TextString := '';
        Cont.SetCurrentKey("VAT Registration No.");
        Cont.SetRange("VAT Registration No.", VATRegNo);
        Cont.SetFilter("No.", '<>%1', Number);
        if Cont.FindSet then begin
            Check := false;
            Finish := false;
            repeat
                AppendString(TextString, Finish, Cont."No.");
            until (Cont.Next = 0) or Finish;
        end;
        if not Check then
            Message(StrSubstNo(Text004, TextString));
    end;

    procedure Test_Santillana(VATRegNo: Text[25]; CountryCode: Code[10]; Number: Code[20]; TableID: Option)
    var
        Check: Boolean;
        t: Text[250];
        CompanyInfo: Record "Company Information";
        cliente: Record Customer;
        Vend: Record Vendor;
        FuncEcuador: Codeunit "Funciones Ecuador";
    begin
        // Si el número de registro de IVA está vacío, salir
        if VATRegNo = '' then
            exit;

        Check := true;

        // Configurar el rango del código de país
        if CountryCode = '' then begin
            CompanyInfo.Get;
            SetRange("Country/Region Code", CompanyInfo."Country/Region Code");
        end else
            SetRange("Country/Region Code", CountryCode);

        SetFilter(Format, '<> %1', '');

        // Validación específica para proveedores
        if TableID = DATABASE::Vendor then begin
            Vend.Get(Number);
            SetRange("Tipo Ruc/Cedula", Vend."Tipo Ruc/Cedula");
            FuncEcuador.ValidaDigitosRUC(VATRegNo, Vend."Tipo Ruc/Cedula", false);
        end;

        // Validación específica para clientes
        if TableID = DATABASE::Customer then begin
            cliente.Get(Number);
            if cliente."Tipo Documento" <> cliente."Tipo Documento"::Pasaporte then begin
                cliente.TestField("Tipo Ruc/Cedula");
                SetRange("Tipo Ruc/Cedula", cliente."Tipo Ruc/Cedula");
                FuncEcuador.ValidaDigitosRUC(VATRegNo, cliente."Tipo Ruc/Cedula", false);
            end;
        end;

        // Validar el formato del número de registro de IVA
        if Find('-') then begin
            repeat
                if t = '' then
                    t := Format
                else
                    if StrLen(t) + StrLen(Format) + 5 <= MaxStrLen(t) then
                        t := t + ', ' + Format
                    else
                        t := t + '...';
                Check := Compare(VATRegNo, Format);
            until Check or (Next = 0);
        end;

        // Lanzar error si el formato no es válido
        if not Check then
            Error(Text000 + Text001, "Country/Region Code", t);

        // Validar duplicados según la tabla
        case TableID of
            DATABASE::Customer:
                CheckCust(VATRegNo, Number);
            DATABASE::Vendor:
                CheckVendor(VATRegNo, Number);
            DATABASE::Contact:
                CheckContact(VATRegNo, Number);
        end;
    end;

    local procedure AppendString(var String: Text; var Finish: Boolean; AppendText: Text)
    begin
        case true of
            Finish:
                exit;
            String = '':
                String := AppendText;
            StrLen(String) + StrLen(AppendText) + 5 <= 250:
                String += ', ' + AppendText;
            else begin
                String += '...';
                Finish := true;
            end;
        end;
    end;


    var
        IdentityManagement: Codeunit "Identity Management";
        Text000: Label 'The entered VAT Registration number is not in agreement with the format specified for Country/Region Code %1.';
        Text001: Label 'The following formats are acceptable: %1';
        Text002: Label 'This VAT registration number has already been entered for the following customers:\ %1';
        Text003: Label 'This VAT registration number has already been entered for the following vendors:\ %1';
        Text004: Label 'This VAT registration number has already been entered for the following contacts:\ %1';
        Text005: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        InvalidVatNumberErr: Label 'Enter a valid VAT number, for example ''GB123456789''.';



}

