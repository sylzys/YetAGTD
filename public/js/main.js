
(function($) {
    function get_date() {
        var currentTime = new Date()
        var month = currentTime.getMonth() + 1
        var day = currentTime.getDate()
        var year = currentTime.getFullYear()
        var hours = currentTime.getHours()
        var minutes = currentTime.getMinutes()
        if (minutes < 10){
        minutes = "0" + minutes
        }
        var part = ""
        if(hours > 11){
        part="PM"
        } else {
        part="AM"
        }
    return (day + "/" +month + "/" + year + " at " + hours + ":" + minutes + " " + part)
    }

    //MODEL
    window.Note = Backbone.Model.extend({    
        defaults : {
            id : "???",
            title : "Note sans titre",
            content : "",
            tags : "",
            created_at : get_date(),
            modified_at : get_date()
        },

        initialize: function(){
           console.log("Note constructor");
           console.log("Need to add to collection");
            this.bind("change", function(){
            console.log("Update");
            this.set({modified_at: get_date()});
            });
            this.bind("error", function(model, error){
            console.log( error );
        });
        }
    });

    //COLLECTION
    window.Notes = Backbone.Collection.extend({
            model : Note,
            url : "/",
           //localStorage : new Store("docs"),
            initialize : function() {
                console.log('Notes collection Constructor');
            }
        });

    //ROUTER
    // window.NotesRouter = Backbone.Router.extend({

    //     initialize : function() {
    //         /* 1- Création d'une collection */
    //         this.notes = new Notes();
    //         /* 2- Chargement de la collection */
    //         this.notes.fetch();

    //         /* 3- Création des vues + affichage */
    //         this.docFormView = new DocFormView({ collection : this.docs });
    //         this.docsView = new DocsCollectionViewTempo({ collection : this.docs });
    //         this.docsView.render();

    //         /* 4- Click sur un lien */
    //         this.route("doc/:id", "doc", function(id){
    //             console.log(id, this.docs.get(id).toJSON());
    //         });
    //     }

    // });

 //VIEW
 // window.NotesView = Backbone.View.extend({
 //    initialize: function() {
 //        this.render();
 //    },
 //    // render: function() {
 //    //     var variables = { label: "hello" };
 //    //     var template = _.template( $('#template').html(), variables );
 //    //     this.el.html( template );
 //    // },
 //    render: function() {
 //        var variables = { label: "hello" };
 //        var template = Mustache.render( $('#template').html(), variables );
 //        this.el.html( template );
 //    },
 //    events: {
 //        "click input[type=button]": "doAlert"
 //    },
 //    doAlert: function (event) {
 //        alert("you clicked on me ??!!");
 //        this.note = new Note({title: $('#search_input').val() });
 //        this.c = new Notes();
 //        this.c.fetch();
 //        this.c.add(this.note);
 //        this.note.save();

 //    }
 // });
 //    var search = new NotesView({el: $('#main') });
 // window.NotesView = Backbone.View.extend({
 //        el : $('#main'),
 //        initialize : function() {
 //            this.template = _.template($('#template').html());
 //        },

 //        render : function() {
 //            var renderedContent = this.template(this.model.toJSON());
 //            $(this.el).html(renderedContent);
 //            return this;
 //        }

 //    });
 // var search = new NotesView({el: $('#main') });
window.NoteViewTempo = Backbone.View.extend({
        events: {
            "click .validate": "doSearch"
        },
        initialize : function() {
           // this.template = _.template($('#doc-template').html());
           this.template = Tempo.prepare('sole_note');
            /*--- binding ---*/
            _.bindAll(this, 'render');
            this.model.bind('change', this.render);
            /*---------------*/
        },

        render : function() {
            this.template.render(this.model.toJSON());
            return this;
        },
       
        doSearch: function( event ){
            // Button clicked, you can access the element that was clicked with event.currentTarget
            alert( "Search for ");
        }

    });

window.NotesCollectionViewTempo = Backbone.View.extend({

        initialize : function() {
            this.template = Tempo.prepare('documents-list');

            /*--- binding ---*/
            _.bindAll(this, 'render');
            this.collection.bind('change', this.render);
            this.collection.bind('add', this.render);
            this.collection.bind('remove', this.render);
            /*---------------*/

        },

        render : function() {
            this.template.render(this.collection.toJSON());
            return this;
        }

    });
 window.NotesRouter = Backbone.Router.extend({

        initialize : function() {
            /* 1- Création d'une collection */
            this.notes = new Notes();
            /* 2- Chargement de la collection */
            this.notes.fetch();

            /* 3- Création des vues + affichage */
            //this.docFormView = new DocFormView({ collection : this.docs });
            this.notesView = new NotesCollectionViewTempo({ collection : this.notes });
            this.notesView.render();

            // /* 4- Click sur un lien */
            // this.route("/:id", "doc", function(id){
            //     //console.log(id, this.docs.get(id).toJSON());
            //     console.log("show me");
            // });
        },
        routes: {
             "/:id": "getPost", // matches http://example.com/#anything-here
            "/val/:id": "validate",
             "/del/:id": "delete",
             "/new/" : "create",
             "*actions": "defaultRoute"             
        },
        getPost: function( id ) {
            // Note the variable in the route definition being passed in here
           alert(id); 
            $(".right_button_link").attr("href", "#/val/"+id);
            note = this.notes.get(id);
            this.one_noteView = new NoteViewTempo({ model : note });
            this.one_noteView.render();
            $('#edit_title').html(note.get("title"));
            $('#edit_content').html(note.get("content"));
        },
        validate: function( id ) {
            // Note the variable in the route definition being passed in here
           //alert(id); 
           
            note = this.notes.get(id);
            alert("cvalidate");
            note.set({title: $('#edit_title').html(), content: $('#edit_content').html()});
            note.save();
            // $('#edit_title').html(note.get("title"));
            // $('#edit_content').html(note.get("content"));
        },
        create: function (id){
            alert("new");
            note = new Note ({id: 5, title: $('#edit_title').html(), content: $('#edit_content').html()});
            this.notes.add(note);
            note.save();
            //  $.ajax({
            //     url:  '/hello',
            //     data: { title: $('#edit_title').text(), content: $('#edit_content').text() },
            //     type:       'POST',
            //     dataType:   'html',
            //     success: function(data) {
            //     alert(data);
            //     },
            //     error : function(data){
            //         alert(data.responseText);
            //     }
            // });
        },
        delete: function (id) {
            note = this.notes.get(id);
            note.destroy();
            //window.location.href = "/";
        },
        defaultRoute: function( actions ){
            // The variable passed in matches the variable in the route definition "actions"
            alert( actions ); 
            note = this.notes.get(1);
             $(".right_button_link").attr("href", "#/val/1");
            this.one_noteView = new NoteViewTempo({ model : note });
            this.one_noteView.render();
        }

    });
$(function() {
        /*--- initialisation du router ---*/
        router = new NotesRouter();

        /*---
            activation du monitoring des "hashchange events"
            et dispatch des routes
        ---*/
        Backbone.history.start();
    });

    //MAIN
      $('.create').click(function(event) {
        alert("link");
           $(".right_button_link").attr("href", "#/new/");
           $('#edit_title').html('').focus();
           $('#edit_content').html('');
        }); 
})(jQuery);

