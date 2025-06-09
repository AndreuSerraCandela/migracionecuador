report 56090 "Hoja Devolucion NC"
{
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         02/12/2013      RRT           Adaptación informes a RTC.
    DefaultLayout = RDLC;
    RDLCLayout = './HojaDevolucionNC.rdlc';


    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(Sales_Header__Sell_to_Customer_Name_; "Sell-to Customer Name")
            {
            }
            column(Sales_Header__Sell_to_Customer_No__; "Sell-to Customer No.")
            {
            }
            column(Sell_to_Address________Sell_to_Address_2_; "Sell-to Address" + ' ' + "Sell-to Address 2")
            {
            }
            column(rCliente__Phone_No__; rCliente."Phone No.")
            {
            }
            column(Sales_Header__No__; "No.")
            {
            }
            column(TODAY; Today)
            {
            }
            /*column(PAG_____FORMAT_CurrReport_PAGENO_; 'PAG.: ' + Format(CurrReport.PageNo))
            {
            }*/
            column(RNC_______rEmpresa__VAT_Registration_No__; 'RNC : ' + rEmpresa."VAT Registration No.")
            {
            }
            column(P_gina_Web_______rEmpresa__Home_Page_; 'Página Web : ' + rEmpresa."Home Page")
            {
            }
            column(E_Mail_______rEmpresa__E_Mail_; 'E-Mail : ' + rEmpresa."E-Mail")
            {
            }
            column(Tels______rEmpresa__Phone_No____________Fax______rEmpresa__Fax_No__; 'Tels. ' + rEmpresa."Phone No." + ' - ' + 'Fax. ' + rEmpresa."Fax No.")
            {
            }
            column(rEmpresa_County; rEmpresa.County)
            {
            }
            column(rEmpresa_Address; rEmpresa.Address)
            {
            }
            column(rEmpresa_Name; rEmpresa.Name)
            {
            }
            column(HOJA_DE_DEVOLUCION_; 'HOJA DE DEVOLUCION')
            {
            }
            column(rCliente_Contact; rCliente.Contact)
            {
            }
            column(CLIENTE_Caption; CLIENTE_CaptionLbl)
            {
            }
            column(CODIGOCaption; CODIGOCaptionLbl)
            {
            }
            column(DESCRIPCIONCaption; DESCRIPCIONCaptionLbl)
            {
            }
            column(CANTIDAD_DEVUELTACaption; CANTIDAD_DEVUELTACaptionLbl)
            {
            }
            column(Sales_Header_Document_Type; "Document Type")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("No.", Type) ORDER(Ascending) WHERE(Type = FILTER(Item));
                column(Sales_Line__No__; "No.")
                {
                }
                column(Sales_Line_Description; Description)
                {
                }
                column(Sales_Line__Sales_Line__Quantity; "Sales Line".Quantity)
                {
                }
                column(txtComentario_1_; txtComentario[1])
                {
                }
                column(txtComentario_2_; txtComentario[2])
                {
                }
                column(txtComentario_3_; txtComentario[3])
                {
                }
                column(txtComentario_4_; txtComentario[4])
                {
                }
                column(TOTAL_BULTOSCaption; TOTAL_BULTOSCaptionLbl)
                {
                }
                column(TOTAL_EJEMPLARES_DEVUELTOSCaption; TOTAL_EJEMPLARES_DEVUELTOSCaptionLbl)
                {
                }
                column(Comentario_Caption; Comentario_CaptionLbl)
                {
                }
                column(SELLO_Y_NOMBRE_DEL_CLIENTECaption; SELLO_Y_NOMBRE_DEL_CLIENTECaptionLbl)
                {
                }
                column(NOMBRE_DE_QUIEN_RECOGECaption; NOMBRE_DE_QUIEN_RECOGECaptionLbl)
                {
                }
                column(FECHACaption; FECHACaptionLbl)
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                lrSalesLine: Record "Sales Line";
            begin
                //+139
                //... Si sólo tuviera cabecera, lo saltamos.
                lrSalesLine.Reset;
                lrSalesLine.SetRange("Document Type", "Document Type");
                lrSalesLine.SetRange("Document No.", "No.");
                if not lrSalesLine.Find('-') then
                    CurrReport.Skip;
                //-139

                //+139
                Clear(txtComentario);
                //-139

                rComentario.Reset;
                rComentario.SetRange("Document Type", rComentario."Document Type"::"Credit Memo");
                rComentario.SetRange("Document Type", "Document Type");
                rComentario.SetRange(rComentario."No.", "No.");
                if rComentario.FindSet then
                    repeat
                        I += 1;
                        txtComentario[I] := rComentario.Comment;
                        rComentario.Next(1);
                    until I = rComentario.Count;

                rCliente.Get("Sell-to Customer No.");
            end;

            trigger OnPreDataItem()
            begin
                rEmpresa.Get;
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
        rCliente: Record Customer;
        rComentario: Record "Sales Comment Line";
        txtComentario: array[15] of Text[200];
        I: Integer;
        rEmpresa: Record "Company Information";
        CLIENTE_CaptionLbl: Label 'CLIENTE:';
        CODIGOCaptionLbl: Label 'CODIGO';
        DESCRIPCIONCaptionLbl: Label 'DESCRIPCION';
        CANTIDAD_DEVUELTACaptionLbl: Label 'CANTIDAD DEVUELTA';
        TOTAL_BULTOSCaptionLbl: Label 'TOTAL BULTOS';
        TOTAL_EJEMPLARES_DEVUELTOSCaptionLbl: Label 'TOTAL EJEMPLARES DEVUELTOS';
        Comentario_CaptionLbl: Label 'Comentario:';
        SELLO_Y_NOMBRE_DEL_CLIENTECaptionLbl: Label 'SELLO Y NOMBRE DEL CLIENTE';
        NOMBRE_DE_QUIEN_RECOGECaptionLbl: Label 'NOMBRE DE QUIEN RECOGE';
        FECHACaptionLbl: Label 'FECHA';
}

