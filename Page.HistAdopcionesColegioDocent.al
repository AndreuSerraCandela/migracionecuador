page 76238 "Hist Adopciones-Colegio-Docent"
{
    ApplicationArea = all;
    Caption = 'Hist Adopciones-Colegio-Docente';
    DataCaptionFields = "Cod. Colegio", "Cod. Docente";
    Editable = false;
    PageType = List;
    SourceTable = "Historico Ranking CVM vertical";
    SourceTableView = SORTING ("Campaña", "Cod. Docente", "Cod. Colegio", "Cod. Local", "Cod. Producto", "Cod. Grado");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Campaña"; rec.Campaña)
                {
                }
                field("Cod. Producto"; rec."Cod. Producto")
                {
                    Editable = false;
                }
                field("Descripción producto"; rec."Descripción producto")
                {
                    Editable = false;
                }
                field("Edicion Coleccion"; rec."Edicion Coleccion")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field(Alumnado; rec.Alumnado)
                {
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field(CDS; rec.CDS)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ConfAPS: Record "Commercial Setup";
        Item: Record Item;
        DefDim: Record "Default Dimension";
        TextoEncabezado: array[30] of Text[30];
        DimValue: Text[60];
        i: Integer;
        gCodDocente: Code[20];
        gCodColegio: Code[20];
}

