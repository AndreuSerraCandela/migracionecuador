#pragma implicitwith disable
page 75000 "Configuracion MDM"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'MdM Setup';
    PageType = Card;
    SourceTable = "Configuracion MDM";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                group(Control1000000024)
                {
                    Caption = 'General';
                    ShowCaption = false;
                    field("Bloquea Datos MDM"; rec."Bloquea Datos MDM")
                    {
                        ToolTip = ' Bloquea los valores MdM para que no sean editables';
                    }
                    field("Obliga Campos MdM"; rec."Obliga Campos MdM")
                    {
                        ToolTip = 'Genera error si no rellenan debidamente todos los campos MdM';
                        Visible = false;
                    }
                    field("URL Async Reply"; rec."URL Async Reply")
                    {
                    }
                    field("URL Notif.MdM"; rec."URL Notif.MdM")
                    {
                        ToolTip = 'Url del Web Service donde notificar a MdM los cambios en productos';
                    }
                    field("Notifica a MdM"; rec."Notifica a MdM")
                    {
                        ToolTip = 'Notifica cambios de productos a MdM';
                    }
                    field("Dias Borrado Historico"; rec."Dias Borrado Historico")
                    {
                        ToolTip = 'Indica con cuantos días tiene que borrarse el histórico.0 No se borra nunca';
                    }
                    field("Sistema Origen"; rec."Sistema Origen")
                    {
                    }
                    field("Estado Inactivo"; rec."Estado Inactivo")
                    {
                        ToolTip = 'Código Estado que provocará que el producto se marque como "Inactivo"';
                    }
                }
                group("Precios Venta")
                {
                    Caption = 'Precios Venta';
                    field("Grupo Precio PVP"; rec."Grupo Precio PVP")
                    {
                        Visible = false;
                    }
                    field("Grupo Precio PROM"; rec."Grupo Precio PROM")
                    {
                        Visible = false;
                    }
                    field("Tipo Precio Venta"; rec."Tipo Precio Venta")
                    {

                        trigger OnValidate()
                        begin
                            SeTEnabled;
                        end;
                    }
                    field("Grupo Precio Cliente"; rec."Grupo Precio Cliente")
                    {
                        Enabled = wEnblGrpClient;
                    }
                    field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                    {
                    }
                }
                group(Control1000000025)
                {
                    Caption = 'Datos Auxiliares Impt.';
                    ShowCaption = false;
                    field("Serie Producto"; rec."Serie Producto")
                    {
                    }
                    field("Control ISBN"; rec."Control ISBN")
                    {
                        ToolTip = 'Determina si debe de comprobarse el algoritmo IBN13';
                    }
                    field("Base Unit of Measure"; rec."Base Unit of Measure")
                    {
                    }
                    field("Divisa Local MdM"; rec."Divisa Local MdM")
                    {
                    }
                }
                group(Control1000000023)
                {
                    Caption = 'Cola De Proyecto';
                    ShowCaption = false;
                    field("Activar Cola Proy. Auto."; rec."Activar Cola Proy. Auto.")
                    {
                        ToolTip = 'Si se activa, la cola de proyecto se activara automaticamente y el mov se activara y desactivara también automaticamente';
                    }
                    field("Cola proyecto"; rec."Cola proyecto")
                    {
                    }
                    field("Mov. cola proyecto"; rec."Mov. cola proyecto")
                    {
                    }
                    field("Job Queue Category"; rec."Job Queue Category")
                    {
                    }
                }
            }
            group(Dimensiones)
            {
                field("Dim Serie/Metodo"; rec."Dim Serie/Metodo")
                {
                    Caption = 'Serie/Metodo';
                }
                field("Dim Destino"; rec."Dim Destino")
                {
                    Caption = 'Destino';
                }
                field("Dim Cuenta"; rec."Dim Cuenta")
                {
                    Caption = 'Cuenta';
                }
                field("Dim Tipo Texto"; rec."Dim Tipo Texto")
                {
                    Caption = 'Tipo Texto';
                }
                field("Dim Materia"; rec."Dim Materia")
                {
                    Caption = 'Materia';
                }
                field("Dim Carga Horaria"; rec."Dim Carga Horaria")
                {
                    Caption = 'Carga Horaria';
                }
                field("Dim Origen"; rec."Dim Origen")
                {
                    Caption = 'Origen';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SeTEnabled;
    end;

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;

    var
        wEnblGrpClient: Boolean;


    procedure SeTEnabled()
    begin
        // SeTEnabled

        wEnblGrpClient := Rec."Tipo Precio Venta" = Rec."Tipo Precio Venta"::"Grupo precio cliente";
    end;
}

#pragma implicitwith restore

