page 76280 "Lista de Atenciones"
{
    ApplicationArea = all;

    CardPageID = "Ficha de Atenciones";
    PageType = List;
    SourceTable = "Cab. Atenciones";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; rec.Codigo)
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Id. Usuario"; rec."Id. Usuario")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field(Documento; rec.Documento)
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field(Address; rec.Address)
                {
                }
                field("Address 2"; rec."Address 2")
                {
                }
                field(City; rec.City)
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field(Distritos; rec.Distritos)
                {
                }
                field(Objetivo; rec.Objetivo)
                {
                }
                field("Area Responsable"; rec."Area Responsable")
                {
                }
                field("Cod. Responsable"; rec."Cod. Responsable")
                {
                }
                field("Nombre responsable"; rec."Nombre responsable")
                {
                }
                field("Fecha Recepción Documento"; rec."Fecha Recepción Documento")
                {
                }
            }
        }
    }

    actions
    {
    }
}

