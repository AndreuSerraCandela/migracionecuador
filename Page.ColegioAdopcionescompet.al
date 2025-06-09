#pragma implicitwith disable
page 76135 "Colegio - Adopciones compet."
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Colegio", "Nombre Colegio", "Cod. Nivel";
    PageType = Card;
    SourceTable = "Colegio - Adopciones compet.";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                }
                field("Cod. Producto Editora"; rec."Cod. Producto Editora")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("Descripcion producto"; rec."Descripcion producto")
                {
                    Editable = false;
                }
                field("Nombre Producto Editora"; rec."Nombre Producto Editora")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Validate("Cod. Colegio", CodColegio);
        Rec.Validate("Cod. Promotor", CodPromotor);
        Rec.Validate("Cod. Producto", CodProducto);
        Rec.Validate("Cod. Nivel", CodNivel);
        Rec."Cod. Grado" := CodGrado;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Cod. Colegio", CodColegio);
        Rec.SetRange("Cod. Promotor", CodPromotor);
        Rec.SetRange("Cod. Producto", CodProducto);
        Rec.SetRange("Cod. Nivel", CodNivel);
        Rec.SetRange("Cod. Grado", CodGrado);
        //MESSAGE('%1',GETFILTERS);
    end;

    var
        CodColegio: Code[20];
        CodPromotor: Code[20];
        CodProducto: Code[20];
        CodNivel: Code[20];
        CodGrado: Code[20];


    procedure RecibeParametros(CodCol: Code[20]; CodProm: Code[20]; CodProd: Code[20]; CodNiv: Code[20]; CodGrad: Code[20])
    begin
        CodColegio := CodCol;
        CodPromotor := CodProm;
        CodProducto := CodProd;
        CodNivel := CodNiv;
        CodGrado := CodGrad;
    end;
}

#pragma implicitwith restore

