table 76014 "Datos auxiliares"
{

    fields
    {
        field(1; "Tipo registro"; Option)
        {
            OptionCaption = 'Hobbies,Areas of interest,Attentions,Sales channel,Specialties,Grade,Materials,Decision level,Jobs,Routes,Type of education,Types of Schools,Type of contacts,Shits,Zones,Main Areas,Sub family,Objetives,Tasks,Reason of loose,Religious order,Educative association,Subject,Bus. line group,Equipments,Iniciales Almacen,Step';
            OptionMembers = Aficiones,"Areas de interés",Atenciones,"Canal de venta",Especialidades,Grados,Materiales,"Nivel de decisión","Puestos de trabajo",Rutas,"Tipo de educacion","Tipos de colegios","Tipos de contactos",Turnos,Zonas,"Area principal","Sub familia",Objetivos,Tareas,"Motivos Perdida","Orden religiosa","Asociacion educativa",Materia,"Grupo de Negocio","Equipos T&E","Iniciales Almacen",Paso,"Modalidad Lectura",Documentos,"Area Curricular";
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Code';
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Aplica Jerarquia Colegio"; Boolean)
        {
            Caption = 'Apply to School Hierarchy';
        }
        field(5; Seleccionar; Boolean)
        {
            Caption = 'Select';
        }
        field(6; Calculo; Decimal)
        {
        }
        field(7; Delegacion; Code[10])
        {

            trigger OnLookup()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimForm.SetTableView(DimVal);
                DimForm.SetRecord(DimVal);
                DimForm.LookupMode(true);
                if DimForm.RunModal = ACTION::LookupOK then begin
                    DimForm.GetRecord(DimVal);
                    Validate(Delegacion, DimVal.Code);
                end;

                Clear(DimForm);
            end;

            trigger OnValidate()
            begin
                ConfAPS.Get();
                ConfAPS.TestField(ConfAPS."Cod. Dimension Delegacion");
                DimVal.Reset;
                DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Delegacion");
                DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                DimVal.SetRange(Code, Delegacion);
                DimVal.FindFirst;
                "Descripcion delegacion" := DimVal.Name;
            end;
        }
        field(8; "Descripcion delegacion"; Text[100])
        {
            Caption = 'Descripción delegación';
            Editable = false;
        }
        field(9; "Orden en informes"; Integer)
        {
        }
        field(10; "Costo Unitario"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(50000; Mostrar; Boolean)
        {
            Caption = 'Show';
            Description = 'SANTINAV-2524';
        }
    }

    keys
    {
        key(Key1; "Tipo registro", Codigo)
        {
            Clustered = true;
        }
        key(Key2; Codigo)
        {
        }
        key(Key3; Descripcion)
        {
        }
        key(Key4; "Orden en informes")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    var
        ConfAPS: Record "Commercial Setup";
        DimVal: Record "Dimension Value";
        DimForm: Page "Dimension Value List";
}

