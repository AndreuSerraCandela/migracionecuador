#pragma implicitwith disable
page 76016 "Ficha Tienda"
{
    ApplicationArea = all;
    // #76946  RRTM  Añadir los campos e-mail e "información zona".
    // #355717 RRT, 06.04.2021: Añadir el nuevo campo "Cantidad devolucion config."
    // #374964 RRT, 26.04.2021: Añadir el campo "Forma de pago NCR" para Ecuador

    PageType = Card;
    SourceTable = Tiendas;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cod. Tienda"; rec."Cod. Tienda")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Almacen"; rec."Cod. Almacen")
                {
                }
                field(Direccion; rec.Direccion)
                {
                }
                field("Direccion 2"; rec."Direccion 2")
                {
                }
                field(Telefono; rec.Telefono)
                {
                }
                field(Fax; rec.Fax)
                {
                }
                field("Pagina web"; rec."Pagina web")
                {
                }
                field("e-mail"; rec."e-mail")
                {
                }
                field("Telefono 2"; rec."Telefono 2")
                {
                }
                field("No. Identificacion Fiscal"; rec."No. Identificacion Fiscal")
                {
                }
                field("Cod. Pais"; rec."Cod. Pais")
                {
                }
                field("Nombre Pais"; rec."Nombre Pais")
                {
                }
                field(Ciudad; rec.Ciudad)
                {
                }
                field("Informacion zona"; rec."Informacion zona")
                {
                }
            }
            group(Funcionalidad)
            {
                field("Instancia Completa SQL"; rec."Instancia Completa SQL")
                {
                }
                field("Descuadre maximo en caja"; rec."Descuadre maximo en caja")
                {
                }
                field("Imp. Minimo Sol. Datos Cliente"; rec."Imp. Minimo Sol. Datos Cliente")
                {
                }
                field("Permite Anulaciones en POS"; rec."Permite Anulaciones en POS")
                {
                }
                field("Permite NC en otro TPV"; rec."Permite NC en otro TPV")
                {
                }
                field("Permite NC en otro Turno"; rec."Permite NC en otro Turno")
                {
                }
                field("Registro En Linea"; rec."Registro En Linea")
                {
                }
                field("Control de caja"; rec."Control de caja")
                {
                }
                field("Arqueo de caja obligatorio"; rec."Arqueo de caja obligatorio")
                {
                }
                field("Agrupar Lineas"; rec."Agrupar Lineas")
                {
                }
                field("No. Maximo de Lineas"; rec."No. Maximo de Lineas")
                {
                    Caption = 'Nº Maximo de Lineas';
                }
                field("No. Reaperturas Permitidas"; rec."No. Reaperturas Permitidas")
                {
                }
                field("Cuenta Excencion IVA"; rec."Cuenta Excencion IVA")
                {
                }
                field("Cantidad devolucion config"; rec."Cantidad devolucion config")
                {
                }
                field("Forma pago para NCR"; rec."Forma pago para NCR")
                {
                    Visible = wEcuador;
                }
            }
            part(Bancos; "Subform Bancos tiendas")
            {
                Caption = 'Bancos';
                SubPageLink = "Cod. Tienda" = FIELD("Cod. Tienda");
            }
            group(Informes)
            {
                field("ID Reporte contado"; rec."ID Reporte contado")
                {
                }
                field("ID Reporte nota credito"; rec."ID Reporte nota credito")
                {
                }
                field("ID Reporte venta a credito"; rec."ID Reporte venta a credito")
                {
                }
                field("ID Reporte cuadre"; rec."ID Reporte cuadre")
                {
                }
                field("ID Reporte contado FE"; rec."ID Reporte contado FE")
                {
                }
                field("ID Reporte nota credito FE"; rec."ID Reporte nota credito FE")
                {
                }
                field("Cantidad de Copias Contado"; rec."Cantidad de Copias Contado")
                {
                    Caption = 'Cantidad de Impresiones Contado';
                }
                field("Cantidad copias nota credito"; rec."Cantidad copias nota credito")
                {
                }
                field("Cantidad de Copias Credito"; rec."Cantidad de Copias Credito")
                {
                    Caption = 'Cantidad de Impresiones Credito';
                }
            }
            group("Recibo TPV")
            {
                field("Descripcion recibo TPV"; rec."Descripcion recibo TPV")
                {
                }
                field("Descripcion recibo TPV 2"; rec."Descripcion recibo TPV 2")
                {
                }
                field("Descripcion recibo TPV 3"; rec."Descripcion recibo TPV 3")
                {
                }
                field("Descripcion recibo TPV 4"; rec."Descripcion recibo TPV 4")
                {
                }
            }
            part(Autorizaciones; "Sub - Aturozicaciones TPV BOL")
            {
                SubPageLink = Tienda = FIELD("Cod. Tienda");
                Visible = wBolivia;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    var

    begin


    end;

    trigger OnOpenPage()
    begin

        ActivarPais();
    end;

    var
        wBolivia: Boolean;
        Error001: Label 'Función Sólo Disponible en Servidor Central';
        wEcuador: Boolean;


    procedure ActivarPais()
    var
        rConf: Record "Configuracion General DsPOS";
    begin

        rConf.Get();
        rConf.TestField(Pais);

        case rConf.Pais of
            rConf.Pais::Bolivia:
                begin
                    wBolivia := true;
                    CurrPage.Autorizaciones.PAGE.recogerPar(Rec."Cod. Tienda");
                end;
            rConf.Pais::Ecuador:
                wEcuador := true;
        end;
    end;
}

#pragma implicitwith restore

