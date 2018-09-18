module NeuralNetwork
  class ApplicationWindow < Gtk::ApplicationWindow
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Set the template from the resources binary
        set_template resource: '/com/neural_network/gtk-run/ui/application_window.ui'

        bind_template_child 'add_new_item_button'
      end
    end

    def initialize(application)
      super application: application

      set_title 'GTK+ Neural Network Main Window'

      add_new_item_button.signal_connect 'clicked' do |button, application|
        puts "OMG! I AM CLICKED"
      end
    end
  end
end