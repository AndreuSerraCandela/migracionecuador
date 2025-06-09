#pragma implicitwith disable
page 55017 "Config. comprobantes elec."
{
    ApplicationArea = all;

    DelayedInsert = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Config. Comprobantes elec.";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Activado; rec.Activado)
                {
                }
                field(Ambiente; rec.Ambiente)
                {
                }
                field("Activar Cod. Contribuyente Esp"; rec."Activar Cod. Contribuyente Esp")
                {
                }
            }
            group(Firma)
            {
                field("Ruta Ejecutable Firma"; rec."Ruta Ejecutable Firma")
                {
                }
                field("Ruta certificado firma"; rec."Ruta certificado firma")
                {
                }
                field("Contraseña certificado firma"; rec."Contraseña certificado firma")
                {
                }
            }
            group("Web Services")
            {
                group(Pruebas)
                {
                    field("Web Service Recepcion pruebas"; rec."Web Service Recepcion pruebas")
                    {
                    }
                    field("Web Service Autoriza. pruebas"; rec."Web Service Autoriza. pruebas")
                    {
                    }
                }
                group("Producción")
                {
                    field("Web Service recep. produccion"; rec."Web Service recep. produccion")
                    {
                    }
                    field("Web Service Autori. produccion"; rec."Web Service Autori. produccion")
                    {
                    }
                }
            }
            group("Rutas XML")
            {
                field("Ruta ficheros XML Facturas"; rec."Ruta ficheros XML Facturas")
                {
                }
                field("Ruta ficheros XML Remisiones"; rec."Ruta ficheros XML Remisiones")
                {
                }
                field("Ruta ficheros XML Nota Credito"; rec."Ruta ficheros XML Nota Credito")
                {
                }
                field("Ruta ficheros XML Nota Debito"; rec."Ruta ficheros XML Nota Debito")
                {
                }
                field("Ruta ficheros XML Retencion"; rec."Ruta ficheros XML Retencion")
                {
                }
                field("Ruta ficheros XML Liquidacion"; rec."Ruta ficheros XML Liquidacion")
                {
                }
                field("Subcarpeta generados"; rec."Subcarpeta generados")
                {
                }
                field("Subcarpeta firmados"; rec."Subcarpeta firmados")
                {
                }
                field("Subcarpeta enviados"; rec."Subcarpeta enviados")
                {
                }
                field("Subcarpeta autorizados"; rec."Subcarpeta autorizados")
                {
                }
            }
            group("Rutas exportación")
            {
                field("Ruta exportacion clientes"; rec."Ruta exportacion clientes")
                {
                }
                field("Ruta exportacion prov."; rec."Ruta exportacion prov.")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Exportar clientes")
            {
                Caption = 'Exportar clientes';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recCfgFE: Record "Config. Comprobantes elec.";
                    recClientes: Record Customer;
                    xmlClientes: XMLport "Exportar clientes FE";
                begin
                    recCfgFE.Get;
                    recCfgFE.TestField("Ruta exportacion clientes");

                    recClientes.Reset;
                    xmlClientes.SetTableView(recClientes);
                    xmlClientes.Run;
                end;
            }
            action("Exportar proveedores")
            {
                Caption = 'Exportar proveedores';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recCfgFE: Record "Config. Comprobantes elec.";
                    recProv: Record Vendor;
                    xmlProv: XMLport "Exportar prov. FE";
                begin
                    recCfgFE.Get;
                    recCfgFE.TestField("Ruta exportacion clientes");

                    recProv.Reset;
                    xmlProv.SetTableView(recProv);
                    xmlProv.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

#pragma implicitwith restore

