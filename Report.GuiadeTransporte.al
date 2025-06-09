report 56018 "Guia de Transporte"
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // LDP: Luis Jose De La Cruz
    // ------------------------------------------------------------------------------
    // No.           Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 002           LDP           23/04/2024       SANTINAV-6431: Se cre campo Municipio/Ciudad
    DefaultLayout = RDLC;
    RDLCLayout = './GuiadeTransporte.rdlc';

    Caption = 'Shipping Guide';

    dataset
    {
        dataitem("Cab. Hoja de Ruta Reg."; "Cab. Hoja de Ruta Reg.")
        {
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Cab__Hoja_de_Ruta_Reg__Hora; Hora)
            {
            }
            column(Cab__Hoja_de_Ruta_Reg___No__Hoja_Ruta_; "No. Hoja Ruta")
            {
            }
            column(Cab__Hoja_de_Ruta_Reg___Cod__Transportista_; "Cod. Transportista")
            {
            }
            column(Cab__Hoja_de_Ruta_Reg___Fecha_Registro_; "Fecha Registro")
            {
            }
            column(Nombre; Nombre)
            {
            }
            column(No__Caption; No__CaptionLbl)
            {
            }
            column(Chofer_Caption; Chofer_CaptionLbl)
            {
            }
            column(Fecha_Caption; Fecha_CaptionLbl)
            {
            }
            column(Pagina_Caption; Pagina_CaptionLbl)
            {
            }
            column(Hora_Caption; Hora_CaptionLbl)
            {
            }
            column(Ruta_Embarque_Caption; Ruta_Embarque_CaptionLbl)
            {
            }
            column(Relacion__EmbarqueCaption; Relacion__EmbarqueCaptionLbl)
            {
            }
            dataitem("Lin. Hoja de Ruta Reg."; "Lin. Hoja de Ruta Reg.")
            {
                DataItemLink = "No. Hoja Ruta" = FIELD("No. Hoja Ruta");
                DataItemTableView = SORTING("No. Hoja Ruta", "No. Linea") ORDER(Ascending);
                RequestFilterFields = "No. Hoja Ruta", "No. Linea";
                column(Lin__Hoja_de_Ruta_Reg___Cod__Cliente_; "Cod. Cliente")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Nombre_Cliente_; "Nombre Cliente")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Cantidad_de_Bultos_; "Cantidad de Bultos")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg__Peso; Peso)
                {
                }
                column(Cust__Address_2_; Cust."Address 2")
                {
                }
                column(Cust_Address; Cust.Address)
                {
                }
                column(Cust__Territory_Code_; Cust."Territory Code")
                {
                }
                column(Cust_City; Cust.City)
                {
                }
                column(NoFact; NoFact)
                {
                }
                column(NoPed; NoPed)
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Condiciones_de_Envio_; "Condiciones de Envio")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg___Comentarios; "Lin. Hoja de Ruta Reg.".Comentarios)
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg____No__Linea_; "Lin. Hoja de Ruta Reg."."No. Linea")
                {
                }
                column(Cod__Cliente_Caption; Cod__Cliente_CaptionLbl)
                {
                }
                column(Estado_Caption; Estado_CaptionLbl)
                {
                }
                column(Direccion_1_Caption; Direccion_1_CaptionLbl)
                {
                }
                column(Direccion_2_Caption; Direccion_2_CaptionLbl)
                {
                }
                column(Ciudad_Caption; Ciudad_CaptionLbl)
                {
                }
                column(Municipio_Caption; Municipio_CaptionLbl)
                {
                }
                column(Observaciones__Caption; Observaciones__CaptionLbl)
                {
                }
                column(No__LineaCaption; No__LineaCaptionLbl)
                {
                }
                column(BultosCaption; BultosCaptionLbl)
                {
                }
                column(PesoCaption; PesoCaptionLbl)
                {
                }
                column(No__FacturaCaption; No__FacturaCaptionLbl)
                {
                }
                column(No__PedidoCaption; No__PedidoCaptionLbl)
                {
                }
                column(Fecha_Entrega_RequeridaCaption; Fecha_Entrega_RequeridaCaptionLbl)
                {
                }
                column(Condiciones_de_envioCaption; Condiciones_de_envioCaptionLbl)
                {
                }
                column(Lin__Hoja_de_Ruta_Reg__No__Hoja_Ruta; "No. Hoja Ruta")
                {
                }
                column(Lin_hoja_de_Ruta_Ship_To_Code; "Ship-to City")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Cust.Get("Cod. Cliente") then;

                    if SSHH.Get("No. Conduce") then
                        NoPed := SSHH."Order No."
                    else
                        NoPed := '';

                    SIH.Reset;
                    SIH.SetRange("Order No.", SSHH."Order No.");
                    if SIH.FindFirst then
                        NoFact := SIH."No."
                    else
                        NoFact := '';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if ShpAgent.Get("Cod. Transportista") then
                    Nombre := ShpAgent.Name
                else
                    Nombre := '';
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
        NombreCliente: Text[100];
        Cust: Record Customer;
        SIH: Record "Sales Invoice Header";
        SSHH: Record "Sales Shipment Header";
        NoFact: Code[20];
        NoPed: Code[20];
        ShpAgent: Record "Shipping Agent";
        Nombre: Text[100];
        No__CaptionLbl: Label 'No.:';
        Chofer_CaptionLbl: Label 'Chofer:';
        Fecha_CaptionLbl: Label 'Fecha:';
        Pagina_CaptionLbl: Label 'Página:';
        Hora_CaptionLbl: Label 'Hora:';
        Ruta_Embarque_CaptionLbl: Label 'Ruta Embarque:';
        Relacion__EmbarqueCaptionLbl: Label 'Relación  Embarque';
        Cod__Cliente_CaptionLbl: Label 'Cód. Cliente:';
        Estado_CaptionLbl: Label 'Estado:';
        Direccion_1_CaptionLbl: Label 'Dirección 1:';
        Direccion_2_CaptionLbl: Label 'Dirección 2:';
        Ciudad_CaptionLbl: Label 'Ciudad:';
        Municipio_CaptionLbl: Label 'Municipio:';
        Observaciones__CaptionLbl: Label 'Observaciones :';
        No__LineaCaptionLbl: Label 'No. Línea';
        BultosCaptionLbl: Label 'Bultos';
        PesoCaptionLbl: Label 'Peso';
        No__FacturaCaptionLbl: Label 'No. Factura';
        No__PedidoCaptionLbl: Label 'No. Pedido';
        Fecha_Entrega_RequeridaCaptionLbl: Label 'Fecha Entrega Requerida';
        Condiciones_de_envioCaptionLbl: Label 'Condiciones de envío';
}

