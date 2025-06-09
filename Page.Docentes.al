#pragma implicitwith disable
page 76034 Docentes
{
    ApplicationArea = all;

    PageType = Card;
    SourceTable = Docentes;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    Editable = false;
                }
                field("No. 2"; rec."No. 2")
                {
                }
                field("Salutation Code"; rec."Salutation Code")
                {
                }
                field("Full Name"; rec."Full Name")
                {
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field(Address; rec.Address)
                {
                }
                field("Address 2"; rec."Address 2")
                {
                }
                field("Referencia Direccion"; rec."Referencia Direccion")
                {
                }
                field("<Cód. país/región>"; rec."Country/Region Code")
                {
                }
                field("Cód. Departamento"; rec.County)
                {
                    Caption = 'State';
                    Editable = true;
                }
                field("Cód Provincia"; rec."Post Code")
                {
                    Caption = 'Cód Provincia';
                }
                field("Cód Distrito"; rec.City)
                {
                    Caption = 'City';
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("Document ID"; rec."Document ID")
                {
                }
                field(Sexo; rec.Sexo)
                {
                }
                field(Hijos; rec.Hijos)
                {
                }
                field("Ano inscripcion CDS"; rec."Ano inscripcion CDS")
                {
                }
                field("Dia Nacimiento"; rec."Dia Nacimiento")
                {
                }
                field("Mes Nacimiento"; rec."Mes Nacimiento")
                {
                }
                field("Ano Nacimiento"; rec."Ano Nacimiento")
                {
                }
                field(Picture; rec.Picture)
                {
                }
                field(Initials; rec.Initials)
                {
                }
                field("External ID"; rec."External ID")
                {
                }
                field("Customer no."; rec."Customer no.")
                {
                }
                field(Bilingue; rec.Bilingue)
                {
                }
                field(Plan; rec.Plan)
                {
                }
                field("Usuario Lectores en red"; rec."Usuario Lectores en red")
                {
                }
                field(Jubilado; rec.Jubilado)
                {
                }
                field("Nivel Docente"; rec."Nivel Docente")
                {
                }
                field("Pertenece al CDS"; rec."Pertenece al CDS")
                {
                }
                field("Situacion general"; rec."Situacion general")
                {
                }
                field("Tipo de contacto"; rec."Tipo de contacto")
                {
                }
                field("Ult. fecha activacion"; rec."Ult. fecha activacion")
                {
                }
                field("Se entrego carne"; rec."Se entrego carne")
                {
                }
                field("Desc Tipo de contacto"; rec."Desc Tipo de contacto")
                {
                }
                field("Cod. Proveedor"; rec."Cod. Proveedor")
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field(Expositor; rec.Expositor)
                {
                }
                field("Usuario creación"; rec."Usuario creación")
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Recibe correos"; rec."Recibe correos")
                {
                }
                field("Recibe llamadas"; rec."Recibe llamadas")
                {
                }
                field("Recibe email"; rec."Recibe email")
                {
                }
                field("Correspondence Type"; rec."Correspondence Type")
                {
                }
                field("Frecuencia uso email"; rec."Frecuencia uso email")
                {
                }
                field("Envio correspondencia"; rec."Envio correspondencia")
                {
                }
                field("Phone No."; rec."Phone No.")
                {
                    Importance = Promoted;
                }
                field("Work No."; rec."Work No.")
                {
                }
                field("Mobile Phone No."; rec."Mobile Phone No.")
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                    Importance = Promoted;
                }
                field("E-Mail 2"; rec."E-Mail 2")
                {
                }
                field("Home Page"; rec."Home Page")
                {
                }
                field(Facebook; rec.Facebook)
                {
                }
                field(Twitter; rec.Twitter)
                {
                }
                field("BB Pin"; rec."BB Pin")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Teacher")
            {
                Caption = '&Teacher';
                action("&Customer's Card")
                {
                    Caption = '&Customer''s Card';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("No.");
                }
                action("&Vendor Card")
                {
                    Caption = '&Vendor Card';
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Cod. Proveedor");
                }
                separator(Action1000000024)
                {
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(15),
                                  "No." = FIELD("No.");
                }
                separator(Action1000000012)
                {
                }
                action("&Schools")
                {
                    Caption = '&Schools';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Lista Colegio - Docentes";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action(Hobbies)
                {
                    Caption = 'Hobbies';
                    RunObject = Page "Docentes - Aficiones";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                separator(Action1000000008)
                {
                }
                action("&Specialities")
                {
                    Caption = '&Specialities';
                    RunObject = Page "Docentes - Especialidades";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("Workshop - Event")
                {
                    Caption = 'Workshop - Event';
                    RunObject = Page "Consulta Asist. Taller/Evento";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
            }
            action("&Eventos y Talleres")
            {
                Caption = '&Eventos y Talleres';
                RunObject = Page "Expositores - Eventos";
                RunPageLink = "Cod. Expositor" = FIELD("Cod. Proveedor");
            }
            group("&Historics")
            {
                Caption = '&Historics';
                action("CDS History")
                {
                    Caption = 'CDS History';
                    RunObject = Page "Historico Docentes - CDS";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("Teacher - Hobbies History")
                {
                    Caption = 'Teacher - Hobbies History';
                    RunObject = Page "Hist. Docentes - Aficiones";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("Teacher - Specialties History")
                {
                    Caption = 'Teacher - Specialties History';
                    RunObject = Page "Hist. Docentes - Espec.";
                    RunPageLink = "Cod. Docente" = FIELD("No.");
                }
                action("School - Teacher History")
                {
                    Caption = 'School - Teacher History';
                    RunObject = Page "Hist Colegio - Docentes";
                }
            }
        }
        area(processing)
        {
            group("&Actions")
            {
                Caption = '&Actions';
                action("&Create as Customer")
                {
                    Caption = '&Create as Customer';
                    Image = AddContacts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Cust.Get(Rec."Customer no.") then
                            Error(Err001);

                        Clear(Cust);
                        Cust.Insert(true);
                        Rec."Customer no." := Cust."No.";
                        Cust.Validate(Name, Rec."Full Name");
                        /*Peru
                        Cust.VALIDATE(Nombres,"First Name" + ' ' + "Name 2");
                        Cust.VALIDATE("Apellido Paterno","Last Name");
                        Cust.VALIDATE("Apellido Materno","Second Last Name");
                        */
                        Cust.Address := Rec.Address;
                        Cust."Address 2" := Rec."Address 2";
                        Cust.City := Rec.City;
                        Cust."Territory Code" := Rec."Territory Code";
                        Cust.Blocked := Cust.Blocked::All;
                        Cust."Phone No." := Rec."Phone No.";
                        //Peru Cust.VALIDATE(DNI,"Document ID");
                        Cust.Validate("Post Code", Rec."Post Code");
                        Cust.County := Rec.County;
                        Cust."E-Mail" := Rec."E-Mail";
                        Cust."Home Page" := Rec."Home Page";
                        Cust.Insert;

                        Message(Msg001);

                    end;
                }
            }
        }
    }

    var
        Err001: Label 'This Teacher is already created as Customer';
        Msg001: Label 'Teacher created as Customer, please, go to Customer''s card and complete the needed information';
        Cust: Record Customer;
}

#pragma implicitwith restore

