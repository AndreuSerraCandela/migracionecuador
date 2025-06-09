#pragma implicitwith disable
page 76083 "Adopciones - Colegio - MRK 2"
{
    ApplicationArea = all;
    // $001 09/06/14 JML : Page basado en el 76082, pero con los grados en vertical.

    Caption = 'School - Adoptions';
    DataCaptionFields = "Cod. Colegio", "Cod. Docente";
    PageType = Card;
    SourceTable = "Ranking CVM vertical";
    SourceTableView = SORTING("Cod. Docente", "Cod. Colegio", "Cod. Local", "Cod. Producto");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
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

    trigger OnOpenPage()
    begin
        Rec.SetRange("Cod. Colegio", gCodColegio);
        Rec.SetRange("Cod. Docente", gCodDocente);
    end;

    var
        ConfAPS: Record "Commercial Setup";
        Item: Record Item;
        DefDim: Record "Default Dimension";
        TextoEncabezado: array[30] of Text[30];
        DimValue: Text[60];
        i: Integer;
        gCodDocente: Code[20];
        gCodColegio: Code[20];


    procedure RecibeParametros(CodDoc: Code[20]; CodCol: Code[20])
    var
        ColAdopDetalle: Record "Colegio - Adopciones Detalle";
        Grados: Record "Datos auxiliares";
    begin
        gCodColegio := CodCol;
        gCodDocente := CodDoc;
        ConfAPS.Get();
        ConfAPS.TestField("Dim para Estad. Adopciones");
        i := 0;

        DimValue := ' ';
        Grados.Reset;
        Grados.SetRange("Tipo registro", Grados."Tipo registro"::Grados);
        Grados.Find('-');
        repeat
            i += 1;
            TextoEncabezado[i] := Grados.Codigo;
        until Grados.Next = 0;


        ColAdopDetalle.Reset;
        ColAdopDetalle.SetCurrentKey("Cod. Colegio", "Linea de negocio", Familia, "Sub Familia", Serie, "Grupo de Negocio");
        ColAdopDetalle.SetRange("Cod. Colegio", CodCol);
        ColAdopDetalle.SetFilter(Adopcion, '<>%1', 0);
        //ColAdopDetalle.SETRANGE("Cod. Nivel",CodNivel);
        //ColAdopDetalle.SETRANGE("Cod. Turno",CodTurno);
        //ColAdopDetalle.SETRANGE("Cod. Grado",CodGrado);
        ColAdopDetalle.FindSet;
        repeat
            if not Rec.Get(CodDoc, CodCol, ColAdopDetalle."Cod. Local", ColAdopDetalle."Cod. Producto", ColAdopDetalle."Cod. Grado") then
                Rec.Init;

            Rec."Cod. Docente" := CodDoc;
            Rec."Cod. Colegio" := ColAdopDetalle."Cod. Colegio";
            Rec."Cod. Nivel" := ColAdopDetalle."Cod. Nivel";
            Rec."Cod. Grado" := ColAdopDetalle."Cod. Grado";
            Rec."Cod. Turno" := ColAdopDetalle."Cod. Turno";
            Rec."Linea de negocio" := ColAdopDetalle."Linea de negocio";
            Rec.Familia := ColAdopDetalle.Familia;
            Rec."Sub Familia" := DimValue;
            Rec.Serie := ColAdopDetalle.Serie;
            //"Cod. Editorial"   := ColAdopDetalle."Cod. Editorial";
            Rec."Cod. Local" := ColAdopDetalle."Cod. Local";
            Rec."Cod. Promotor" := ColAdopDetalle."Cod. Promotor";
            Rec."Cod. Producto" := ColAdopDetalle."Cod. Producto";
            Rec.Alumnado := ColAdopDetalle."Adopcion Real";  //$001
            Rec.Adopcion := ColAdopDetalle.Adopcion;
            Item.Get(Rec."Cod. Producto");

            DefDim.Reset;
            DefDim.SetRange("Table ID", 27);
            DefDim.SetRange("No.", Rec."Cod. Producto");
            DefDim.SetRange("Dimension Code", 'EDICION_COLECCION');
            if DefDim.FindFirst then
                Rec."Edicion Coleccion" := DefDim."Dimension Value Code";

            Rec."Descripción producto" := Item.Description;

            if not Rec.Insert then
                Rec.Modify;
        until ColAdopDetalle.Next = 0;
    end;
}

#pragma implicitwith restore

