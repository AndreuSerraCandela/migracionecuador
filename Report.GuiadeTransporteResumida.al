report 56024 "Guia de Transporte Resumida"
{
    // #4161     PLB  26/09/2014  Se pide que muestre el nº de factura que corresponde a la guía, pero esto no es posible
    //                            tal como trabajan. Si se factura desde el pedido, la factura y la guía no quedan
    //                            relacionados.
    // 
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // LDP: Luis Jose De La Cruz
    // ------------------------------------------------------------------------------
    // No.           Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 002           LDP           23/04/2024       SANTINAV-6431: Se cre campo Municipio/Ciudad
    DefaultLayout = RDLC;
    RDLCLayout = './GuiadeTransporteResumida.rdlc';

    Caption = 'Shipping Guide';

    dataset
    {
        dataitem("Cab. Hoja de Ruta Reg."; "Cab. Hoja de Ruta Reg.")
        {
            RequestFilterFields = "No. Hoja Ruta";
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
            column(Cab_Hoja_de_Ruta_Reg_Ayudnates; "Cab. Hoja de Ruta Reg.".Ayudantes)
            {
            }
            column(Cab_Hoja_de_Ruta_NombreChofer; "Cab. Hoja de Ruta Reg."."Nombre Chofer")
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
            column(Pagina_Caption; Página_CaptionLbl)
            {
            }
            column(Hora_Caption; Hora_CaptionLbl)
            {
            }
            column(Ruta_Embarque_Caption; Ruta_Embarque_CaptionLbl)
            {
            }
            column(Relacion__EmbarqueCaption; Relación__EmbarqueCaptionLbl)
            {
            }
            column(No__LineaCaption; No__LíneaCaptionLbl)
            {
            }
            column(Cod__ClienteCaption; Cód__ClienteCaptionLbl)
            {
            }
            column(Nombre_ClienteCaption; Nombre_ClienteCaptionLbl)
            {
            }
            column(EstadoCaption; EstadoCaptionLbl)
            {
            }
            column(CiudadCaption; CiudadCaptionLbl)
            {
            }
            column(MunicipioCaption; MunicipioCaptionLbl)
            {
            }
            column(No__FacturaCaption; No__FacturaCaptionLbl)
            {
            }
            column(No__PedidoCaption; No__PedidoCaptionLbl)
            {
            }
            column(BultosCaption; BultosCaptionLbl)
            {
            }
            column(PesoCaption; PesoCaptionLbl)
            {
            }
            column(Fecha_Entrega_RequeridaCaption; Fecha_Entrega_RequeridaCaptionLbl)
            {
            }
            column(Condiciones_de_envioCaption; Condiciones_de_envíoCaptionLbl)
            {
            }
            column(Observaciones_Caption; Observaciones_CaptionLbl)
            {
            }
            column(Ayudantes_Caption; Ayudantes_Caption)
            {
            }
            column(Horario_Entrega_Caption; HorarioEntrega_CaptionLbl)
            {
            }
            column(Entrega_En_Caption; EntregaEn_CaptionLbl)
            {
            }
            dataitem("Lin. Hoja de Ruta Reg."; "Lin. Hoja de Ruta Reg.")
            {
                DataItemLink = "No. Hoja Ruta" = FIELD("No. Hoja Ruta");
                DataItemTableView = SORTING("No. Hoja Ruta", "No. Linea") ORDER(Ascending);
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
                column(Cust__Territory_Code_; Cust."Territory Code")
                {
                }
                column(Cust_City; Cust.City)
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg____Fecha_Entrega_Requerida_; "Lin. Hoja de Ruta Reg."."Fecha Entrega Requerida")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg____Condiciones_de_Envio_; "Lin. Hoja de Ruta Reg."."Condiciones de Envio")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg___Comentarios; "Lin. Hoja de Ruta Reg.".Comentarios)
                {
                }
                column(NoFact; "No. Factura")
                {
                }
                column(NoPed; "No. Pedido")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg__No__Hoja_Ruta; "No. Hoja Ruta")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg__No__Linea; "No. Linea")
                {
                }
                column(Horario_Entrega_; "Horario Entrega")
                {
                }
                column(Entrega_En_; "Entrega En")
                {
                }
                column(Lin_hoja_de_Ruta_Ship_To_Code; "Ship-to City")
                {
                }

                trigger OnAfterGetRecord()
                var
                    FinBucle: Boolean;
                begin
                    if Cust.Get("Cod. Cliente") then;

                    //+#4161
                    //IF SSHH.GET("No. Conduce") THEN
                    //  NoPed := SSHH."Order No."
                    //ELSE
                    //  NoPed := '';
                    //
                    //NoFact := ''; //+#4161
                    //FinBucle := FALSE; //+#4161
                    //
                    //SIH.RESET;
                    //SIH.SETCURRENTKEY("Order No."); //+#4161
                    //SIH.SETRANGE("Order No.",SSHH."Order No.");
                    //IF SIH.FINDFIRST THEN
                    //  NoFact := SIH."No."
                    //ELSE
                    //  NoFact := '';
                    //-#4161
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
        ShpAgent: Record "Shipping Agent";
        Nombre: Text[100];
        No__CaptionLbl: Label 'No.:';
        Chofer_CaptionLbl: Label 'Chofer:';
        Fecha_CaptionLbl: Label 'Fecha:';
        "Página_CaptionLbl": Label 'Página:';
        Hora_CaptionLbl: Label 'Hora:';
        Ruta_Embarque_CaptionLbl: Label 'Ruta Embarque:';
        "Relación__EmbarqueCaptionLbl": Label 'Relación  Embarque';
        "No__LíneaCaptionLbl": Label 'No. Línea';
        "Cód__ClienteCaptionLbl": Label 'Cód. Cliente';
        Nombre_ClienteCaptionLbl: Label 'Nombre Cliente';
        EstadoCaptionLbl: Label 'Estado';
        CiudadCaptionLbl: Label 'Ciudad';
        MunicipioCaptionLbl: Label 'Municipio';
        No__FacturaCaptionLbl: Label 'No. Factura';
        No__PedidoCaptionLbl: Label 'No. Pedido';
        BultosCaptionLbl: Label 'Bultos';
        PesoCaptionLbl: Label 'Peso';
        Fecha_Entrega_RequeridaCaptionLbl: Label 'Fecha Entrega Requerida';
        "Condiciones_de_envíoCaptionLbl": Label 'Condiciones de envío';
        Observaciones_CaptionLbl: Label 'Observaciones ';
        Ayudantes_Caption: Label 'Ayudantes:';
        HorarioEntrega_CaptionLbl: Label 'Horario Entrega';
        EntregaEn_CaptionLbl: Label 'Entrega En';
}

