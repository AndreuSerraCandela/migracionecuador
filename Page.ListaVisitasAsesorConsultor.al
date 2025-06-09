page 76317 "Lista Visitas Asesor/Consultor"
{
    ApplicationArea = all;

    CardPageID = "Ficha Visitas Asesor/Consultor";
    PageType = List;
    SourceTable = "Cab. Visita Asesor/Consultor";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Visita Asesor/Consultor"; rec."No. Visita Asesor/Consultor")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                }
                field("Hora Registro"; rec."Hora Registro")
                {
                }
                field("Usuario Registro"; rec."Usuario Registro")
                {
                }
                field("Cod. Asesor/Consultor"; rec."Cod. Asesor/Consultor")
                {
                }
                field("Nombre Asesor/Consultor"; rec."Nombre Asesor/Consultor")
                {
                }
                field("Delegación"; rec.Delegación)
                {
                }
                field("Grupo Negocio"; rec."Grupo Negocio")
                {
                }
                field("Tipo Visita"; rec."Tipo Visita")
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Dirección Colegio"; rec."Dirección Colegio")
                {
                }
                field("Distrito Colegio"; rec."Distrito Colegio")
                {
                }
                field("Teléfono 1 Colegio"; rec."Teléfono 1 Colegio")
                {
                }
                field("Teléfono 2 Colegio"; rec."Teléfono 2 Colegio")
                {
                }
                field("Cod. promotor"; rec."Cod. promotor")
                {
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Tipo Persona Contacto"; rec."Tipo Persona Contacto")
                {
                }
                field("Cod. Persona Contacto"; rec."Cod. Persona Contacto")
                {
                }
                field("Nombre Persona Contacto"; rec."Nombre Persona Contacto")
                {
                }
                field("No. Asistentes Esperados"; rec."No. Asistentes Esperados")
                {
                }
                field("No. Asistentes Reales"; rec."No. Asistentes Reales")
                {
                }
                field(Estado; rec.Estado)
                {
                }
            }
        }
    }

    actions
    {
    }
}

