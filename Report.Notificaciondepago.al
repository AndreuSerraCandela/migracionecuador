report 76003 "Notificacion de pago"
{
    RDLCLayout = './Notificaciondepago.rdlc';
    WordLayout = './Notificaciondepago.docx';
    Caption = 'Notification of payment';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            CalcFields = "Original Amount";
            DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code") WHERE("Document Type" = FILTER(" " | Payment));
            RequestFilterFields = "Vendor No.", "Posting Date", "Document No.";
            column(Vendor_No_; "Vendor No.")
            {
            }
            column(Full_Name; Vendor.Name)
            {
            }
            column(RNC; Vendor."VAT Registration No.")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Concepto_; Concepto)
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            column(Amount; Format("Original Amount", 0, '<Integer Thousand><Decimals,3>'))
            {
            }
            column(Dia; Format(Today, 0, '<Day,2>'))
            {
            }
            column(Nombre_Dia; NombreDia)
            {
            }
            column(Nombre_Mes; NombreMes)
            {
            }
            column(Nombre_Ano; Format(Today, 0, '<Year4>'))
            {
            }
            column(Importe_Texto; ImporteTexto[1])
            {
            }
            column(Nombre_Empresa; Company.Name)
            {
            }
            column(RNC_Empresa; Company."VAT Registration No.")
            {
            }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                //Comentado DataItemLink = '';
                DataItemTableView = SORTING("Vendor Ledger Entry No.", "Posting Date");
                column(VEDocument_No_; VLE."Document No.")
                {
                }
                column(VECurrency_Code; VLE."Currency Code")
                {
                }
                column(VEAmount_; Amount)
                {
                }
                column(VEPosting_Date; Format(VLE."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                {
                }
                column(VENCF; VLE."No. Comprobante Fiscal")
                {
                }
                column(VE_Original_Amount; VLE."Original Amount" * -1)
                {
                }

                trigger OnAfterGetRecord()
                var
                    PIH: Record "Purch. Inv. Header";
                begin
                    VLE.Get("Vendor Ledger Entry No.");
                    if PIH.Get(VLE."Document No.") then
                        VLE."No. Comprobante Fiscal" := PIH."No. Comprobante Fiscal"
                    else
                        VLE."No. Comprobante Fiscal" := '';
                    VLE.CalcFields("Original Amount");

                    //MESSAGE('%1 %2 %3',"Document No.",Amount);
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Vendor Ledger Entry No.", '<>%1', "Vendor Ledger Entry"."Entry No.");
                    SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                    SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                    SetRange("Entry Type", "Entry Type"::Application);
                    //setrange("document type","document type"::payment);

                    DVLE.Reset;
                    DVLE.SetCurrentKey("Vendor Ledger Entry No.", "Posting Date");
                    DVLE.SetRange("Vendor Ledger Entry No.", "Vendor Ledger Entry"."Entry No.");
                    DVLE.SetRange("Posting Date", "Vendor Ledger Entry"."Posting Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.Get("Vendor No.");

                case Format(Today, 0, '<Month,2>') of
                    '01':
                        NombreMes := 'Enero';
                    '02':
                        NombreMes := 'Febrero';
                    '03':
                        NombreMes := 'Marzo';
                    '04':
                        NombreMes := 'Abril';
                    '05':
                        NombreMes := 'Mayo';
                    '06':
                        NombreMes := 'Junio';
                    '07':
                        NombreMes := 'Julio';
                    '08':
                        NombreMes := 'Agosto';
                    '09':
                        NombreMes := 'Septiembre';
                    '10':
                        NombreMes := 'Octubre';
                    '11':
                        NombreMes := 'Noviembre';
                    else
                        NombreMes := 'Diciembre';
                end;

                //ChkTransMgt.FormatNoText(ImporteTexto, Amount, 2058, '');
            end;

            trigger OnPreDataItem()
            begin
                Company.Get();
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

    var
        Vendor: Record Vendor;
        VLE: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        //ChkTransMgt: Report "Check Translation Management";
        Company: Record "Company Information";
        NombreDia: Text[60];
        NombreMes: Text[60];
        ImporteTexto: array[2] of Text[1024];
        Concepto: Text[1024];
        Desc: Integer;
}

