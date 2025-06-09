page 76309 "Lista seleccion entrenamientos"
{
    ApplicationArea = all;
    Caption = 'Training selection list';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Cab. Entrenamiento";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Seleccionado; Seleccionado)
                {
                    Caption = 'Selected';

                    trigger OnValidate()
                    begin
                        if Seleccionado then begin
                            Clear(Asistentesentrenam);
                            Asistentesentrenam.Validate("No. entrenamiento", rec."No. entrenamiento");
                            Asistentesentrenam.Validate("Cod. entrenamiento", rec.Disponible);
                            Asistentesentrenam.Validate("Fecha programacion", rec."Fecha Inicio");
                            Asistentesentrenam.Validate("No. empleado", gCodEmpl);
                            Asistentesentrenam.Validate("Cod. Instructor");
                            if Asistentesentrenam.Insert(true) then;
                        end
                        else begin
                            Asistentesentrenam.Reset;
                            Asistentesentrenam.SetRange("Cod. entrenamiento", rec.Disponible);
                            Asistentesentrenam.SetRange("Tipo entrenamiento", rec."Tipo entrenamiento");
                            Asistentesentrenam.SetRange("Cod. Instructor", rec."Cod. Instructor");
                            if Asistentesentrenam.FindSet() then
                                repeat
                                    Asistentesentrenam.Delete(true);
                                until Asistentesentrenam.Next = 0;
                        end;
                    end;
                }
                field("No. entrenamiento"; rec."No. entrenamiento")
                {
                    Editable = false;
                }
                field("Tipo entrenamiento"; rec."Tipo entrenamiento")
                {
                    Editable = false;
                }
                field(Disponible; rec.Disponible)
                {
                    Editable = false;
                }
                field("Titulo entrenamiento"; rec."Titulo entrenamiento")
                {
                }
                field("Tipo de Instructor"; rec."Tipo de Instructor")
                {
                    Editable = false;
                }
                field("Cod. Instructor"; rec."Cod. Instructor")
                {
                    Editable = false;
                }
                field("Nombre Instructor"; rec."Nombre Instructor")
                {
                }
                field("Numero de sesiones"; rec."Numero de sesiones")
                {
                    Editable = false;
                }
                field("Fecha Inicio"; rec."Fecha Inicio")
                {
                    Editable = false;
                }
                field(Lunes; rec.Lunes)
                {
                    Editable = false;
                }
                field(Martes; rec.Martes)
                {
                    Editable = false;
                }
                field(Miercoles; rec.Miercoles)
                {
                    Editable = false;
                }
                field(Jueves; rec.Jueves)
                {
                    Editable = false;
                }
                field(Viernes; rec.Viernes)
                {
                    Editable = false;
                }
                field(Sabados; rec.Sabados)
                {
                    Editable = false;
                }
                field(Domingos; rec.Domingos)
                {
                    Editable = false;
                }
                field("Asistentes esperados"; rec."Asistentes esperados")
                {
                    Editable = false;
                }
                field("Total registrados"; rec."Total registrados")
                {
                    Editable = false;
                }
                field(Estado; rec.Estado)
                {
                    Editable = false;
                }
                field("Asistentes reales"; rec."Asistentes reales")
                {
                    Editable = false;
                }
                field("Area Curricular"; rec."Area Curricular")
                {
                    Editable = false;
                }
                field(Sala; rec.Sala)
                {
                    Editable = false;
                }
                field(Tipo; rec.Tipo)
                {
                }
                field("Hora de Inicio"; rec."Hora de Inicio")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000027; "Asist. Ent - Empleados Factbox")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No. entrenamiento" = FIELD("No. entrenamiento");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Seleccionado := false;
        Asistentesentrenam.Reset;
        Asistentesentrenam.SetRange("No. entrenamiento", rec."No. entrenamiento");
        Asistentesentrenam.SetRange("Cod. Instructor", rec."Cod. Instructor");
        Asistentesentrenam.SetRange("No. empleado", gCodEmpl);
        Asistentesentrenam.SetRange("Tipo entrenamiento", rec."Tipo entrenamiento");
        if Asistentesentrenam.FindFirst then
            Seleccionado := true;
    end;

    var
        Asistentesentrenam: Record "Asistentes entrenamientos";
        Seleccionado: Boolean;
        gCodEmpl: Code[20];


    procedure RecibeParametro(CodEmpleado: Code[20])
    begin
        gCodEmpl := CodEmpleado;
    end;
}

