// schema:type=namespace schema:namespace=polygon
package LaunchpadNamespaces

#namespaces: {
	// Polygon *Namespace*
	#polygon: {
		meta: {
			name: "polygon"
			url:  "https://github.com/graphops/launchpad-namespaces/\(name)"
			description: """
				This *Namespace* provides a suitable stack to operate Polygon mainnet archive nodes.
				"""
		}

		#flavor: {
			// suitable defaults for a mainnet archive node
			#mainnet: "mainnet"

			#enum: ( #mainnet )
		}

		// polygon namespace values schema
		#values: #base.#values & {
			// the default is polygon-<flavor>
			targetNamespace?: *"polygon-mainnet" | string

			_templatedTargetNamespace: '( print "polygon-" .Values.flavor )'

			flavor?: *"mainnet" | #flavor.#enum

			#releaseValues: {
				mergeValues?: *true | bool
				values?:      (#map) | [...#map]
			}

			// For overriding this release's values
			for key, _ in releases {
				// For overriding this release's values
				(key)?: #releaseValues
			}
		}

		// polygon helmfile API
		#helmfiles: #base.#helmfiles & {
			path:    =~"*github.com/graphops/launchpad-namespaces.git@polygon/helmfile.yaml*"
			values?: #polygon.#values | [...#polygon.#values]
		}

		releases: {
			erigon: {
				chart: {_repositories.graphops.charts.erigon}
				_template: {version: "0.8.2"}
			}

			heimdall: {
				chart: {_repositories.graphops.charts.heimdall}
				_template: {version: "1.1.3-canary.3"}
			}

			proxyd: {
				chart: {_repositories.graphops.charts.proxyd}
				_template: {version: "0.3.4-canary.4"}
			}
		}

		labels: {
			#base.#labels
			"launchpad.graphops.xyz/namespace": "polygon"
		}
	}
}

// instantiate namespace ojects for internal usage
_namespaces: "polygon": _#namespaceTemplate & {_key: #namespaces.#polygon}
