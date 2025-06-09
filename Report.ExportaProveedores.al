report 56014 "Exporta Proveedores"
{
    Caption = 'Export Vendors';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                I += 1;

                TestField(Name);
                TestField("Country/Region Code");
                TestField("VAT Registration No.");

                if Blocked <> Blocked::" " then
                    Estado := txt002
                else
                    Estado := txt001;

                if PC.Get("Post Code", City) then
                    Provincia := PC.County
                else
                    Provincia := '';

                NoProv := CopyStr("No.", 6, StrLen("No."));
                CR.Get("Country/Region Code");

                CL.Reset;
                CL.SetRange("Table Name", 2);
                CL.SetRange(CL."No.", "No.");
                if CL.FindFirst then
                    Comentario := CL.Comment
                else
                    Comentario := '';

                if I = 1 then begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn('Cód. Autor', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Estado', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Nombre', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Direccion', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Cód. Postal', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Ciudad', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Provincia', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('País', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('RFC', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Teléfono', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Fax', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('E-Mail', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Contacto', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Alias', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn('Comentario', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                end;

                ExcelBuf.NewRow;
                ExcelBuf.AddColumn(NoProv, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Estado, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Address, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Post Code", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(City, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Provincia, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(CR.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("VAT Registration No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Phone No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Fax No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("E-Mail", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Contact, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn("Search Name", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Comentario, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.SetUseInfoSheet;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Estado: Text[10];
        txt001: Label 'Activo';
        txt002: Label 'Inactivo';
        Text001: Label 'Proveedor (Aut.-Ag. -Prop.)';
        PC: Record "Post Code";
        Provincia: Code[20];
        NoProv: Code[20];
        CR: Record "Country/Region";
        CL: Record "Comment Line";
        Comentario: Text[200];
        I: Integer;

    local procedure MakeExcelDataBody()
    begin
    end;

    local procedure CreateExcelbook()
    begin
        /*         ExcelBuf.CreateBookAndOpenExcel('', Text001, '', CompanyName, UserId); */
        Error('');
    end;
}

