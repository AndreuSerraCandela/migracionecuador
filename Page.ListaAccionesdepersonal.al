page 76062 "Lista Acciones de personal"
{
    ApplicationArea = all;
    Caption = 'Personnel activities list';
    CardPageID = "Ficha Acciones de personal";
    Editable = false;
    PageType = List;
    SourceTable = "Acciones de personal";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Tipo de accion"; rec."Tipo de accion")
                {
                }
                field("Cod. accion"; rec."Cod. accion")
                {
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Nombre completo"; rec."Nombre completo")
                {
                }
                field("ID Documento"; rec."ID Documento")
                {
                }
                field("Descripcion accion"; rec."Descripcion accion")
                {
                }
                field("Fecha accion"; rec."Fecha accion")
                {
                }
                field("Fecha efectividad"; rec."Fecha efectividad")
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
                field("Cargo actual"; rec."Cargo actual")
                {
                }
                field("Descripcion cargo actual"; rec."Descripcion cargo actual")
                {
                }
                field("Nuevo cargo"; rec."Nuevo cargo")
                {
                }
                field("Descripcion cargo nuevo"; rec."Descripcion cargo nuevo")
                {
                }
                field("Sueldo actual"; rec."Sueldo actual")
                {
                }
                field("Sueldo Nuevo"; rec."Sueldo Nuevo")
                {
                }
                field("Departamento actual"; rec."Departamento actual")
                {
                }
                field("Nombre  depto. actual"; rec."Nombre  depto. actual")
                {
                }
                field("Departamento nuevo"; rec."Departamento nuevo")
                {
                }
                field("Nombre depto. nuevo"; rec."Nombre depto. nuevo")
                {
                }
                field("Ubicacion actual"; rec."Ubicacion actual")
                {
                }
                field("Ubicacion nueva"; rec."Ubicacion nueva")
                {
                }
                field("Empresa nueva"; rec."Empresa nueva")
                {
                }
                field("Numero cuenta actual"; rec."Numero cuenta actual")
                {
                }
                field("Numero cuenta nueva"; rec."Numero cuenta nueva")
                {
                }
                field("Nivel actual"; rec."Nivel actual")
                {
                }
                field("Nivel nuevo"; rec."Nivel nuevo")
                {
                }
                field("Tipo de contrato"; rec."Tipo de contrato")
                {
                }
                field("Preparado por"; rec."Preparado por")
                {
                }
                field("Revisado por"; rec."Revisado por")
                {
                }
                field("Autorizado por"; rec."Autorizado por")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Convenio")
            {
                Caption = '&Convenio';
                action(Ficha)
                {
                    Caption = 'Ficha';
                    RunObject = Page "Gpo. Contable Empleados";
                    ShortCutKey = 'Shift+F7';
                }
                action(Action15)
                {
                    Caption = 'C&omentarios';
                    RunObject = Page "Comentarios nóminas";
                }
            }
        }
    }
}

