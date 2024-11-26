import 'package:dev_garage/core/db/app_database.dart';
import 'package:dev_garage/core/locator.dart';
import 'package:dev_garage/core/locator_root.dart';
import 'package:dev_garage/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'link_manager_notifier.dart';

final formKey = GlobalKey<ShadFormState>();

class LinkManagerScreen extends StatefulWidget {
  const LinkManagerScreen({super.key});

  @override
  State<LinkManagerScreen> createState() => _LinkManagerScreenState();
}

class _LinkManagerScreenState extends State<LinkManagerScreen> {
  late final linkNotifier = LinkManagerNotifier(context.get());

  @override
  void dispose() {
    linkNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: linkNotifier,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Expanded(flex: 1, child: _Sidebar(linkNotifier)),
                VerticalDivider(),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ShadInput(
                                controller: linkNotifier.searchController,
                                placeholder: Text("Search..."),
                              ),
                            ),
                            ShadButton(
                              icon: Icon(Icons.add),
                              child: Text("Add Link"),
                              onPressed: () {
                                final linkTitleController =
                                    TextEditingController();
                                final linkController = TextEditingController();
                                showShadDialog(
                                    context: context,
                                    builder: (context) {
                                      return ShadDialog(
                                        title: const Text("Add Link"),
                                        child: ShadForm(
                                          key: formKey,
                                          child: Column(
                                            children: [
                                              ShadInputFormField(
                                                key: Key("link_title_field"),
                                                placeholder: Text("Title"),
                                                controller: linkTitleController,
                                                validator: (value) {
                                                  if (value.trim().isEmpty) {
                                                    return "Link title is required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 16),
                                              ShadInputFormField(
                                                key: Key("link_url_field"),
                                                placeholder: Text("URL"),
                                                controller: linkController,
                                                validator: (value) {
                                                  if (value.trim().isEmpty) {
                                                    return "Link url is required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 16),
                                              ShadButton(
                                                key: Key("add_link_button"),
                                                child: const Text("Add"),
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    final database = context
                                                        .get<AppDatabase>();
                                                    final title =
                                                        linkTitleController.text
                                                            .trim();
                                                    final link = linkController
                                                        .text
                                                        .trim();
                                                    database
                                                        .into(database.links)
                                                        .insert(LinksCompanion
                                                            .insert(
                                                                title: title,
                                                                url: link));
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.start,
                              children: [
                                ...linkNotifier.links.map(
                                  (e) {
                                    return InkWell(
                                      onTap: () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(e.url))) {
                                          launchUrl(Uri.parse(e.url));
                                        }
                                      },
                                      child: ShadCard(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.title,
                                              style: ShadTheme.of(context)
                                                  .textTheme
                                                  .large,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              e.url.shorten(maxLength: 25),
                                              overflow: TextOverflow.ellipsis,
                                              style: ShadTheme.of(context)
                                                  .textTheme
                                                  .small,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  final LinkManagerNotifier linkManagerNotifier;

  const _Sidebar(this.linkManagerNotifier);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Categories",
                style: ShadTheme.of(context).textTheme.list,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showAddCategoryDialog(context);
              },
            )
          ],
        ),
        ...linkManagerNotifier.categories.map(
          (e) {
            return ListTile(
              title: Text(e.name),
            );
          },
        ),
      ],
    );
  }
}

void showAddCategoryDialog(BuildContext context) {
  final categoryNameController = TextEditingController();
  showShadDialog(
    context: context,
    builder: (context) {
      return ShadDialog(
        title: const Text("Add Category"),
        child: ShadForm(
          key: formKey,
          child: Column(
            children: [
              ShadInputFormField(
                placeholder: Text("Category name"),
                controller: categoryNameController,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Category name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ShadButton(
                child: const Text("Add"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final database = Locator().get<AppDatabase>();
                    final name = categoryNameController.text.trim();
                    database
                        .into(database.linkCategories)
                        .insert(LinkCategoriesCompanion.insert(name: name));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
