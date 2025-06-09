table 76060 "Centros de Trabajo"
{
    LookupPageID = "Centros de Trabajo";

    fields
    {
        field(1; "Empresa cotización"; Code[20])
        {
            TableRelation = "Empresas Cotizacion";

            trigger OnValidate()
            begin
                if EmpCotizacion.Get("Empresa cotización") then begin
                    if Dirección = '' then
                        Dirección := EmpCotizacion.Direccion;
                    Población := EmpCotizacion.Provincia;
                    Validate("C.P.", EmpCotizacion."Codigo Postal");
                end;
            end;
        }
        field(2; "Centro de trabajo"; Code[20])
        {
            NotBlank = true;
            Numeric = true;

            trigger OnValidate()
            begin
                if StrLen("Centro de trabajo") < 3 then Error('Valor comprendido entre 001 y 999');
            end;
        }
        field(3; "Dirección"; Text[40])
        {
        }
        field(4; "C.P."; Text[20])
        {
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                cpostal.SetRange(Code, "C.P.");
                if Población <> '' then
                    cpostal.SetRange(City, Población);
                if cpostal.FindFirst then begin
                    Población := cpostal.City;
                end;
            end;
        }
        field(5; "Población"; Text[30])
        {
        }
        field(6; Provincia; Text[30])
        {
        }
        field(7; "Fecha de Cierre Nomina"; Date)
        {
        }
        field(8; Nombre; Text[60])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "Empresa cotización", "Centro de trabajo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Centro de trabajo", Nombre, "Dirección", Provincia)
        {
        }
    }

    var
        EmpCotizacion: Record "Empresas Cotizacion";
        cpostal: Record "Post Code";
}

