page 76246 "Historico Plan Lector Ficha"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Historico Plan Lector Cab.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Campaña"; rec.Campaña)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Descripcion Local"; rec."Descripcion Local")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Descripcion Turno"; rec."Descripcion Turno")
                {
                }
                field(Distrito; rec.Distrito)
                {
                }
                field("Cod. Delegacion"; rec."Cod. Delegacion")
                {
                    Editable = false;
                }
                field("Descripción Delegacion"; rec."Descripción Delegacion")
                {
                    Editable = false;
                }
            }
            part(Detalle; "Historico Plan Lector Subpage")
            {
                Caption = 'Detalle';
                SubPageLink = "Campaña" = FIELD("Campaña"),
                              "Cod. Colegio" = FIELD("Cod. Colegio"),
                              "Cod. Local" = FIELD("Cod. Local"),
                              "Cod. Turno" = FIELD("Cod. Turno");
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }


    procedure Cargar(CodColegio: Code[20]; CodLocal: Code[20]; CodTurno: Code[20])
    var
        recGrados: Record "Colegio - Grados";
        recPL: Record "Plan Lector Det.";
        Texto001: Label 'Si realiza la carga de datos, se borrarán los datos existentes. ¿Desea continuar?';
        recAdop: Record "Colegio - Adopciones Detalle";
    begin
        recPL.Reset;
        recPL.SetRange("Cod. Colegio", CodColegio);
        if CodLocal <> '' then recPL.SetRange("Cod. Local", CodLocal);
        recPL.SetRange("Cod. Turno", CodTurno);
        if recPL.FindFirst then
            if Confirm(Texto001) then
                recPL.DeleteAll
            else
                exit;
        recPL.Reset;
        recGrados.SetRange("Cod. Colegio", CodColegio);
        if CodLocal <> '' then recGrados.SetRange("Cod. Local", CodLocal);
        recGrados.SetRange("Cod. Turno", CodTurno);
        if recGrados.FindSet then
            repeat
                recPL.Init;
                recPL."Cod. Colegio" := recGrados."Cod. Colegio";
                recPL."Cod. Local" := recGrados."Cod. Local";
                recPL."Cod. Turno" := recGrados."Cod. Turno";
                recPL."Cod. Nivel" := recGrados."Cod. Nivel";
                recPL."Cod. Grado" := recGrados."Cod. Grado";
                recPL."Cantidad Docentes" := recGrados."Cantidad Secciones";
                recPL."Cantidad Alumnos" := recGrados."Cantidad Alumnos";
                recPL."Cantidad Docentes" := recGrados."Cantidad Docentes";

                recAdop.Reset;
                recAdop.SetCurrentKey("Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto");
                recAdop.SetRange("Cod. Colegio", recPL."Cod. Colegio");
                recAdop.SetRange("Grupo de Negocio", 'PLAN LECTOR');
                recAdop.SetRange("Cod. Turno", recPL."Cod. Turno");
                recAdop.SetFilter(Adopcion, '%1|%2', recAdop.Adopcion::Conquista, recAdop.Adopcion::Mantener);
                recAdop.SetRange("Item - Item Category Code", recPL."Cod. Nivel");
                recAdop.SetRange("Item - Grado", recPL."Cod. Grado");
                if recAdop.FindSet then begin
                    recPL."Edit. 1" := 'S';
                    repeat
                        recPL."Cant. x Alum 1" += recAdop."Adopcion Real";
                        recPL."Adopción real" += recAdop."Adopcion Real";
                    until recAdop.Next = 0;
                    if recPL."Cantidad Alumnos" <> 0 then
                        recPL.Validate("Cant. x Alum 1", Round(recPL."Cant. x Alum 1" / recPL."Cantidad Alumnos", 1));
                end;
                recPL.Insert;
            until recGrados.Next = 0;
    end;
}

