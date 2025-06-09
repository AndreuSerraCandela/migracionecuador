report 56025 "Hoja de Ruta No Registrada"
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // LDP: Luis Jose De La Cruz
    // ------------------------------------------------------------------------------
    // No.           Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 002           LDP           23/04/2024       SANTINAV-6431: Se cre campo Municipio/Ciudad
    DefaultLayout = RDLC;
    RDLCLayout = './HojadeRutaNoRegistrada.rdlc';

    Caption = 'Shipping Guide';
    UseRequestPage = true;
    UseSystemPrinter = true;

    dataset
    {
        dataitem("Cab. Hoja de Ruta"; "Cab. Hoja de Ruta")
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
            column(Cab_Hoja_de_Ruta_Reg_Ayudnates; Ayudantes)
            {
            }
            column(Cab_Hoja_de_Ruta_NombreChofer; "Nombre Chofer")
            {
            }
            column(Cab__Hoja_de_Ruta_Reg___Fecha_Registro_; "Cab. Hoja de Ruta"."Fecha Planificacion Transporte")
            {
            }
            column(Cab_Hoja_de_Ruta_Reg_Zona; "Cab. Hoja de Ruta".Zona)
            {
            }
            column(Cab_Hoja_de_Ruta_Almacen; "Cab. Hoja de Ruta".Almacen)
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
            column(Entrega_en_caption; Entrega_En_Caption)
            {
            }
            column(Horario_entrega_caption; Horario_Entrega_Caption)
            {
            }
            dataitem("Lin. Hoja de Ruta"; "Lin. Hoja de Ruta")
            {
                DataItemLink = "No. Hoja Ruta" = FIELD("No. Hoja Ruta");
                DataItemTableView = SORTING("No. Hoja Ruta", "No. Linea") ORDER(Ascending);
                column(NumeroGuia_LinHojadeRuta; "Lin. Hoja de Ruta"."Numero Guia")
                {
                }
                column(NombreGuia_LinHojadeRuta; "Lin. Hoja de Ruta"."Nombre Guia")
                {
                }
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
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg____Fecha_Entrega_Requerida_; "Fecha Entrega Requerida")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg____Condiciones_de_Envio_; "Condiciones de Envio")
                {
                }
                column(Lin__Hoja_de_Ruta_Reg___Lin__Hoja_de_Ruta_Reg___Comentarios; Comentarios)
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
                column(Lin_hoja_de_Ruta_Reg_no_DireccionEnv; "Lin. Hoja de Ruta"."Direccion de Envio")
                {
                }
                column(Lin_Hoja_de_Ruta_Reg_no_NoDocumento; "Lin. Hoja de Ruta"."Comprobante Fiscal")
                {
                }
                column(Lin_hoja_de_Ruta_Reg_NoPedido; "Lin. Hoja de Ruta"."No. Pedido")
                {
                }
                column(Lin_hoja_de_Ruta_Reg_Alias; "Lin. Hoja de Ruta".Alias)
                {
                }
                column(Lin_hoja_de_Ruta_Entrega_En; "Lin. Hoja de Ruta"."Entrega En")
                {
                }
                column(Lin_hoja_de_Ruta_Horario_Entrega; "Lin. Hoja de Ruta"."Horario Entrega")
                {
                }
                column(Lin_hoja_de_Ruta_Ship_To_Code; "Ship-to City")
                {
                }

                trigger OnAfterGetRecord()
                var
                    FinBucle: Boolean;
                begin
                    //IF Cust.GET("Cod. Cliente") THEN;
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
        "Relación__EmbarqueCaptionLbl": Label 'Relación  Embarque /  NO REGISTRADA';
        "No__LíneaCaptionLbl": Label 'No. Línea';
        "Cód__ClienteCaptionLbl": Label 'Cód. Cliente';
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
        Entrega_En_Caption: Label 'Entrega En';
        Horario_Entrega_Caption: Label 'Horario Entrega';
}

