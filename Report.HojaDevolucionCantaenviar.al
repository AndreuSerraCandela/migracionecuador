report 56084 "Hoja Devolucion Cant. a enviar"
{
    // ------------------------------------------------------------------------
    // No.         Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 139         03/12/2013      RRT           Adaptación informes a RTC.
    DefaultLayout = RDLC;
    RDLCLayout = './HojaDevolucionCantaenviar.rdlc';


    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            RequestFilterFields = "No.";
            column(Transfer_Header__Transfer_from_Name_; "Transfer-from Name")
            {
            }
            column(Transfer_Header__Transfer_from_Code_; "Transfer-from Code")
            {
            }
            column(Transfer_from_Address___________Transfer_from_Address_2_; "Transfer-from Address" + ' ' + "Transfer-from Address 2")
            {
            }
            column(rCliente__Phone_No__; rCliente."Phone No.")
            {
            }
            column(Transfer_Header__No__; "No.")
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
            column(Transfer_Header__Transfer_Header___External_Document_No__; "Transfer Header"."External Document No.")
            {
            }
            column(rCliente_City; rCliente.City)
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
            column(CANTIDAD_CONSIGNADACaption; CANTIDAD_CONSIGNADACaptionLbl)
            {
            }
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING(Description, "Item No.") ORDER(Ascending);
                column(Transfer_Line__Item_No__; "Item No.")
                {
                }
                column(Transfer_Line_Description; Description)
                {
                }
                column(Transfer_Line__Transfer_Line___Qty__to_Ship_; "Transfer Line"."Qty. to Ship")
                {
                }
                column(CantidadConsig; CantidadConsig)
                {
                }
                column(Transfer_Line___Qty__to_Ship_; "Transfer Line"."Qty. to Ship")
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
                column(TOTAL_UNIDADES_DEVUELTASCaption; TOTAL_UNIDADES_DEVUELTASCaptionLbl)
                {
                }
                column(Comentario_Caption; Comentario_CaptionLbl)
                {
                }
                column(SELLO_Y_NOMBRE_DEL_CLIENTECaption; SELLO_Y_NOMBRE_DEL_CLIENTECaptionLbl)
                {
                }
                column(FECHACaption; FECHACaptionLbl)
                {
                }
                column(NOMBRE_DE_QUIEN_RECOGECaption; NOMBRE_DE_QUIEN_RECOGECaptionLbl)
                {
                }
                column(Transfer_Line_Document_No_; "Document No.")
                {
                }
                column(Transfer_Line_Line_No_; "Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                lrTransferLine: Record "Transfer Line";
            begin
                //+139
                Clear(txtComentario);
                //-139

                //+139
                //... Si sólo tuviera cabecera, lo saltamos.
                lrTransferLine.Reset;
                lrTransferLine.SetRange("Document No.", "No.");
                if not lrTransferLine.Find('-') then
                    CurrReport.Skip;
                //-139

                //+139
                I := 0;
                //-139

                rComentario.Reset;
                rComentario.SetRange("Document Type", rComentario."Document Type"::"Transfer Order");
                rComentario.SetRange("No.", "No.");
                if rComentario.FindSet then
                    repeat
                        I += 1;
                        txtComentario[I] := rComentario.Comment;
                        rComentario.Next(1);
                    until I = rComentario.Count;

                //+139
                //rCliente.GET("Transfer-from Code");
                if not rCliente.Get("Transfer-from Code") then
                    Clear(rCliente);
                //-139
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
        rComentario: Record "Inventory Comment Line";
        txtComentario: array[15] of Text[200];
        I: Integer;
        rEmpresa: Record "Company Information";
        rItem: Record Item;
        CantidadConsig: Decimal;
        rItemLedgerEntry: Record "Item Ledger Entry";
        CLIENTE_CaptionLbl: Label 'CLIENTE:';
        CODIGOCaptionLbl: Label 'CODIGO';
        DESCRIPCIONCaptionLbl: Label 'DESCRIPCION';
        CANTIDAD_DEVUELTACaptionLbl: Label 'CANTIDAD DEVUELTA';
        CANTIDAD_CONSIGNADACaptionLbl: Label 'CANTIDAD CONSIGNADA';
        TOTAL_BULTOSCaptionLbl: Label 'TOTAL BULTOS';
        TOTAL_UNIDADES_DEVUELTASCaptionLbl: Label 'TOTAL UNIDADES DEVUELTAS';
        Comentario_CaptionLbl: Label 'Comentario:';
        SELLO_Y_NOMBRE_DEL_CLIENTECaptionLbl: Label 'SELLO Y NOMBRE DEL CLIENTE';
        FECHACaptionLbl: Label 'FECHA';
        NOMBRE_DE_QUIEN_RECOGECaptionLbl: Label 'NOMBRE DE QUIEN RECOGE';
}

