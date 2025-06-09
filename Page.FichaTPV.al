#pragma implicitwith disable
page 76029 "Ficha TPV"
{
    ApplicationArea = all;
    // #116527 RRT, 22.01.2018: Incluir los nuevos campos "NCF Credito fiscal resguardo" y "NCF Credito fiscal NCR resg.", "NCF Credito fiscal habitual" y
    //              "NCF Credito fiscal NCR habit.".
    // #116510 RRT. 07.11.2018: Visualizacion de los campos NCF

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Configuracion TPV";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Tienda; rec.Tienda)
                {

                    trigger OnValidate()
                    begin

                        if Rec.Tienda <> '' then
                            ActivarRestricciones;
                    end;
                }
                field("Id TPV"; rec."Id TPV")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Usuario windows"; rec."Usuario windows")
                {
                    Editable = false;
                }
                field("Venta Movil"; rec."Venta Movil")
                {
                }
            }
            group(Numeradores)
            {
                field("No. serie Facturas"; rec."No. serie Facturas")
                {
                    Caption = 'Nº. Serie Facturas';
                }
                field("No. serie facturas Reg."; rec."No. serie facturas Reg.")
                {
                    Caption = 'Nº serie facturas Registradas';
                }
                field("No. serie notas credito"; rec."No. serie notas credito")
                {
                    Enabled = wAnulaciones;
                }
                field("No. serie notas credito reg."; rec."No. serie notas credito reg.")
                {
                    Enabled = wAnulaciones;
                }
            }
            group("Menús")
            {
                field("Menu de acciones"; rec."Menu de acciones")
                {
                }
                field("Menu de productos"; rec."Menu de productos")
                {
                }
                field("Menu de Formas de Pago"; rec."Menu de Formas de Pago")
                {
                }
            }
            group(Dominicana)
            {
                Visible = wDominicana;
                field("NCF Consumidor final"; rec."NCF Consumidor final")
                {
                }
                field("NCF Credito fiscal"; rec."NCF Credito fiscal")
                {
                }
                field("NCF Regimenes especiales"; rec."NCF Regimenes especiales")
                {
                }
                field("NCF Gubernamentales"; rec."NCF Gubernamentales")
                {
                }
                field("<NCF Anulaciones>"; rec."NCF Credito fiscal NCR")
                {
                    Caption = 'NCF Anulaciones';
                }
            }
            group(Bolivia)
            {
                Visible = wBolivia;
                field("Serie Ventas Computerizadas"; rec."Serie Ventas Computerizadas")
                {
                }
                field("Leyenda Dosificacion"; rec."Leyenda Dosificacion")
                {
                }
            }
            group(Paraguay)
            {
                Visible = wParaguay;
                field("<NCF. Credito fiscal>"; rec."NCF Credito fiscal")
                {
                    Caption = 'Serie NCF Facturas';
                }
                field("NCF Credito fiscal NCR"; rec."NCF Credito fiscal NCR")
                {
                    Caption = 'Serie NCF Notas Crédito';
                    Enabled = wAnulaciones;
                }
            }
            group(Ecuador)
            {
                Visible = wEcuador;
                field("<NCF.. Credito fiscal>"; rec."NCF Credito fiscal")
                {
                    Caption = 'Serie NCF Facturas';
                }
                field("<NCF.. Credito fiscal NCR>"; rec."NCF Credito fiscal NCR")
                {
                    Caption = 'Serie NCF Notas Crédito';
                    Enabled = wAnulaciones;
                }
            }
            group(Guatemala)
            {
                Visible = wGuatemala;
                field("<NCF... Credito fiscal>"; rec."NCF Credito fiscal habitual")
                {
                    Caption = 'Serie NCF Facturas';
                }
                field("<NCF... Credito fiscal NCR>"; rec."NCF Credito fiscal NCR habit.")
                {
                    Caption = 'Serie NCF Notas Crédito';
                    Enabled = wAnulaciones;
                }
                field("NCF Credito fiscal resguardo"; rec."NCF Credito fiscal resguardo")
                {
                    Caption = 'Serie NCF Facturas resguardo';
                }
                field("NCF Credito fiscal NCR resg."; rec."NCF Credito fiscal NCR resg.")
                {
                    Caption = 'Serie NCF Notas Crédito resguardo';
                }
            }
            group("El Salvador")
            {
                Visible = wSalvador;
                field("<NCF.... Credito fiscal>"; rec."NCF Credito fiscal")
                {
                    Caption = 'Serie NCF Facturas';
                }
                field("<NCF.... Credito fiscal NCR>"; rec."NCF Credito fiscal NCR")
                {
                    Caption = 'Serie NCF Notas Crédito';
                    Enabled = wAnulaciones;
                }
            }
            group(Honduras)
            {
                Visible = wHonduras;
                field("<NCF..... Credito fiscal>"; rec."NCF Credito fiscal")
                {
                    Caption = 'Serie NCF Facturas';
                }
                field("<NCF..... Credito fiscal NCR>"; rec."NCF Credito fiscal NCR")
                {
                    Caption = 'Serie NCF Notas Crédito';
                    Enabled = wAnulaciones;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Desvincular)
            {
                Caption = 'Statistics';
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F7';

                trigger OnAction()
                begin

                    Rec."Usuario windows" := '';
                    Rec.Modify(false);
                end;
            }
            action(Vincular)
            {
                Caption = '&Asignar Usuario';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin

                    Rec."Usuario windows" := cfAdd.TraerUsuarioWindows();
                    Rec.Modify(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActivarRestricciones;
    end;

    trigger OnInit()
    var
        Error001: Label 'Función Sólo Disponible en Servidor Central';
    begin

    end;

    trigger OnOpenPage()
    var
        rConf: Record "Configuracion General DsPOS";

    begin
        ActivarPais;
        ActivarRestricciones;

        //+#116527
        //... Gestion de las series NCFs.
        //IF wGuatemala THEN
        //  lcGuatemala.GestionSeriesNCF;
        //-#116527
    end;

    var
        wDominicana: Boolean;
        wBolivia: Boolean;
        wParaguay: Boolean;
        wAnulaciones: Boolean;
        wEcuador: Boolean;

        cfAdd: Codeunit "Funciones Addin DSPos";
        wGuatemala: Boolean;
        wSalvador: Boolean;
        wHonduras: Boolean;


    procedure ActivarPais()
    var
        rConf: Record "Configuracion General DsPOS";
    begin

        rConf.Get();
        rConf.TestField(Pais);

        case rConf.Pais of
            rConf.Pais::Bolivia:
                wBolivia := true;
            rConf.Pais::"Republica Dominicana":
                wDominicana := true;
            rConf.Pais::Paraguay:
                wParaguay := true;
            rConf.Pais::Ecuador:
                wEcuador := true;
            rConf.Pais::Guatemala:
                wGuatemala := true;
            rConf.Pais::Salvador:
                wSalvador := true;
            rConf.Pais::Honduras:
                wHonduras := true;  //+#166510
        end;
    end;


    procedure ActivarRestricciones()
    begin


    end;
}

#pragma implicitwith restore

